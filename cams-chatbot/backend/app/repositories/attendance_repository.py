from typing import Optional, Dict, Any, List, Tuple
from app.repositories.base import BaseRepository

class AttendanceRepository(BaseRepository):
    """
    Data access repository for attendance tracking domain.
    Queries the actual CAMS PostgreSQL dataset (staff_attendance, users, faculty_profiles, leaves).
    Enforces RBAC and strictly parameterized queries.
    """

    def get_summary(self, user_role: str = "ADMIN", user_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Calculates authoritative summary metrics from real database records.
        """
        # 1. Base counts
        sql_counts = """
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT sa.faculty_id) as total_members_tracked,
                COUNT(DISTINCT sa.date) as total_days_recorded,
                SUM(CASE WHEN LOWER(sa.status) = 'present' THEN 1 ELSE 0 END) as present_count,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absent_count,
                SUM(CASE WHEN LOWER(sa.status) IN ('leave', 'rest leave', 'on duty', 'od') THEN 1 ELSE 0 END) as leave_count,
                SUM(CASE WHEN LOWER(sa.status) = 'sunday' THEN 1 ELSE 0 END) as sunday_count
            FROM staff_attendance sa
            WHERE sa.is_deleted = false
        """
        params = {}
        if user_role == "FACULTY" and user_id:
            sql_counts += " AND sa.faculty_id = :user_id"
            params["user_id"] = user_id
        elif user_role == "STUDENT" and user_id:
            sql_counts += " AND sa.faculty_id = :user_id"
            params["user_id"] = user_id

        counts_rows = self.execute_query(sql_counts, params=params, user_role=user_role)
        counts = counts_rows[0] if counts_rows else {
            "total_records": 0,
            "total_members_tracked": 0,
            "total_days_recorded": 0,
            "present_count": 0,
            "absent_count": 0,
            "leave_count": 0,
            "sunday_count": 0
        }

        # 2. Per-member attendance calculation to determine risk categories
        sql_members = """
            SELECT 
                sa.faculty_id,
                u.full_name as member_name,
                COUNT(*) as total_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as present_or_excused,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absences,
                SUM(CASE WHEN LOWER(sa.status) IN ('leave', 'rest leave', 'on duty', 'od') THEN 1 ELSE 0 END) as leaves
            FROM staff_attendance sa
            JOIN users u ON u.id = sa.faculty_id
            WHERE sa.is_deleted = false
        """
        if user_role in ("FACULTY", "STUDENT") and user_id:
            sql_members += " AND sa.faculty_id = :user_id"
        sql_members += " GROUP BY sa.faculty_id, u.full_name"

        member_rows = self.execute_query(sql_members, params=params, user_role=user_role)
        
        healthy_count = 0      # >= 85%
        moderate_count = 0     # 75% - 84%
        attention_count = 0    # < 75%
        member_percentages = []

        for m in member_rows:
            total = m.get("total_days", 0)
            present_or_excused = m.get("present_or_excused", 0)
            pct = round((present_or_excused / total * 100), 1) if total > 0 else 0.0
            member_percentages.append(pct)

            if pct >= 85.0:
                healthy_count += 1
            elif pct >= 75.0:
                moderate_count += 1
            else:
                attention_count += 1

        overall_pct = round(sum(member_percentages) / len(member_percentages), 1) if member_percentages else 0.0

        return {
            "overall_attendance_pct": overall_pct,
            "total_members_tracked": counts.get("total_members_tracked", 0),
            "total_records_logged": counts.get("total_records", 0),
            "total_days_recorded": counts.get("total_days_recorded", 0),
            "present_count": counts.get("present_count", 0),
            "absent_count": counts.get("absent_count", 0),
            "leave_count": counts.get("leave_count", 0),
            "sunday_count": counts.get("sunday_count", 0),
            "healthy_count": healthy_count,
            "moderate_count": moderate_count,
            "attention_required_count": attention_count,
            "threshold_healthy": 85.0,
            "threshold_warning": 75.0
        }

    def list_records(
        self,
        user_role: str = "ADMIN",
        user_id: Optional[str] = None,
        search: Optional[str] = None,
        status_filter: Optional[str] = None,
        date_from: Optional[str] = None,
        date_to: Optional[str] = None,
        page: int = 1,
        page_size: int = 15,
        sort_by: str = "date",
        sort_order: str = "DESC"
    ) -> Tuple[List[Dict[str, Any]], int]:
        """
        Retrieves paginated, filtered attendance records.
        """
        params: Dict[str, Any] = {}
        conditions = ["sa.is_deleted = false"]

        if user_role in ("FACULTY", "STUDENT") and user_id:
            conditions.append("sa.faculty_id = :user_id")
            params["user_id"] = user_id

        if status_filter and status_filter.upper() != "ALL":
            conditions.append("UPPER(sa.status) = :status_filter")
            params["status_filter"] = status_filter.upper()

        if search:
            conditions.append("(LOWER(u.full_name) LIKE :search OR LOWER(sa.status) LIKE :search OR CAST(sa.date AS TEXT) LIKE :search)")
            params["search"] = f"%{search.lower()}%"

        if date_from:
            conditions.append("sa.date >= :date_from")
            params["date_from"] = date_from

        if date_to:
            conditions.append("sa.date <= :date_to")
            params["date_to"] = date_to

        where_clause = " WHERE " + " AND ".join(conditions)

        # Count total matching rows
        count_sql = f"""
            SELECT COUNT(*)
            FROM staff_attendance sa
            JOIN users u ON u.id = sa.faculty_id
            {where_clause}
        """
        count_res = self.execute_query(count_sql, params=params, user_role=user_role)
        total_count = list(count_res[0].values())[0] if count_res else 0

        # Allowed sort fields
        sort_field_map = {
            "date": "sa.date",
            "name": "u.full_name",
            "status": "sa.status",
            "source": "sa.source"
        }
        order_field = sort_field_map.get(sort_by, "sa.date")
        order_dir = "ASC" if sort_order.upper() == "ASC" else "DESC"

        offset = max(0, (page - 1) * page_size)
        params["limit"] = page_size
        params["offset"] = offset

        data_sql = f"""
            SELECT 
                sa.id,
                sa.faculty_id,
                u.full_name as member_name,
                u.email as member_email,
                u.role as member_role,
                sa.date,
                sa.status,
                sa.check_in,
                sa.check_out,
                sa.working_hours,
                sa.source,
                sa.created_at
            FROM staff_attendance sa
            JOIN users u ON u.id = sa.faculty_id
            {where_clause}
            ORDER BY {order_field} {order_dir}, sa.id ASC
            LIMIT :limit OFFSET :offset
        """
        records = self.execute_query(data_sql, params=params, user_role=user_role)
        return records, total_count

    def get_risk_panel(self, user_role: str = "ADMIN", user_id: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Returns members requiring attendance attention (< 75% or at-risk) with exact metrics.
        """
        params: Dict[str, Any] = {}
        sql = """
            SELECT 
                sa.faculty_id as entity_id,
                u.full_name as name,
                u.role as role,
                u.email as email,
                COUNT(*) as total_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as attended_days,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absent_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('leave', 'rest leave', 'on duty', 'od') THEN 1 ELSE 0 END) as leave_days
            FROM staff_attendance sa
            JOIN users u ON u.id = sa.faculty_id
            WHERE sa.is_deleted = false
        """
        if user_role in ("FACULTY", "STUDENT") and user_id:
            sql += " AND sa.faculty_id = :user_id"
            params["user_id"] = user_id
        sql += " GROUP BY sa.faculty_id, u.full_name, u.role, u.email"

        rows = self.execute_query(sql, params=params, user_role=user_role)
        results = []
        for r in rows:
            tot = r.get("total_days", 0)
            att = r.get("attended_days", 0)
            pct = round((att / tot * 100), 1) if tot > 0 else 0.0

            status_label = "Healthy" if pct >= 85.0 else ("Monitor" if pct >= 75.0 else "Attention Required")
            results.append({
                "entity_id": r.get("entity_id"),
                "name": r.get("name"),
                "role": r.get("role"),
                "email": r.get("email"),
                "total_days": tot,
                "attended_days": att,
                "absent_days": r.get("absent_days", 0),
                "leave_days": r.get("leave_days", 0),
                "attendance_pct": pct,
                "status": status_label
            })

        results.sort(key=lambda x: x["attendance_pct"])
        return results

    def get_analytics_charts(self, user_role: str = "ADMIN", user_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Returns structured datasets for Chart 1 (Bar), Chart 2 (Line), Chart 3 (Donut/Pie).
        """
        params: Dict[str, Any] = {}
        where_cond = "WHERE sa.is_deleted = false"
        if user_role in ("FACULTY", "STUDENT") and user_id:
            where_cond += " AND sa.faculty_id = :user_id"
            params["user_id"] = user_id

        # Chart 1: Attendance by Member/Faculty (Bar Chart)
        sql_bar = f"""
            SELECT 
                u.full_name as label,
                COUNT(*) as total_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as attended_days,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absences
            FROM staff_attendance sa
            JOIN users u ON u.id = sa.faculty_id
            {where_cond}
            GROUP BY u.full_name
            ORDER BY u.full_name ASC
        """
        bar_rows = self.execute_query(sql_bar, params=params, user_role=user_role)
        bar_chart_data = []
        for b in bar_rows:
            tot = b.get("total_days", 0)
            att = b.get("attended_days", 0)
            pct = round((att / tot * 100), 1) if tot > 0 else 0.0
            bar_chart_data.append({
                "subject": b.get("label"),
                "attendance": pct,
                "total_days": tot,
                "absences": b.get("absences", 0)
            })

        # Chart 2: Attendance Trend over Dates (Line Chart)
        sql_line = f"""
            SELECT 
                sa.date,
                COUNT(*) as total_logged,
                SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as attended_count,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absent_count
            FROM staff_attendance sa
            {where_cond}
            GROUP BY sa.date
            ORDER BY sa.date ASC
        """
        line_rows = self.execute_query(sql_line, params=params, user_role=user_role)
        line_chart_data = []
        for l in line_rows:
            tot = l.get("total_logged", 0)
            att = l.get("attended_count", 0)
            pct = round((att / tot * 100), 1) if tot > 0 else 0.0
            line_chart_data.append({
                "date": str(l.get("date")),
                "attendance": pct,
                "present": att,
                "absent": l.get("absent_count", 0)
            })

        # Chart 3: Distribution by Status / Risk (Pie/Donut Chart)
        sql_pie = f"""
            SELECT 
                sa.status as status_name,
                COUNT(*) as record_count
            FROM staff_attendance sa
            {where_cond}
            GROUP BY sa.status
            ORDER BY record_count DESC
        """
        pie_rows = self.execute_query(sql_pie, params=params, user_role=user_role)
        pie_chart_data = [
            {"name": p.get("status_name", "Unknown"), "value": p.get("record_count", 0)}
            for p in pie_rows
        ]

        return {
            "by_subject": bar_chart_data,
            "trend": line_chart_data,
            "distribution": pie_chart_data
        }

    def get_detail(self, entity_id: str, user_role: str = "ADMIN", user_id: Optional[str] = None) -> Optional[Dict[str, Any]]:
        """
        Retrieves detailed profile & logs for a specific member.
        """
        # RBAC Check: Students & Faculty can only view their own detail
        if user_role in ("FACULTY", "STUDENT") and user_id and entity_id != user_id:
            return None

        # 1. User information
        user_sql = """
            SELECT u.id, u.full_name, u.email, u.role
            FROM users u
            WHERE u.id = :entity_id
        """
        user_rows = self.execute_query(user_sql, params={"entity_id": entity_id}, user_role=user_role)
        if not user_rows:
            return None
        user_info = user_rows[0]

        # 2. Summary stats for this member
        stats_sql = """
            SELECT 
                COUNT(*) as total_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('present', 'sunday') THEN 1 ELSE 0 END) as attended_days,
                SUM(CASE WHEN LOWER(sa.status) = 'absent' THEN 1 ELSE 0 END) as absent_days,
                SUM(CASE WHEN LOWER(sa.status) IN ('leave', 'rest leave', 'on duty', 'od') THEN 1 ELSE 0 END) as leave_days
            FROM staff_attendance sa
            WHERE sa.faculty_id = :entity_id AND sa.is_deleted = false
        """
        stats_rows = self.execute_query(stats_sql, params={"entity_id": entity_id}, user_role=user_role)
        stats = stats_rows[0] if stats_rows else {"total_days": 0, "attended_days": 0, "absent_days": 0, "leave_days": 0}
        
        tot = stats.get("total_days", 0)
        att = stats.get("attended_days", 0)
        pct = round((att / tot * 100), 1) if tot > 0 else 0.0
        risk = "Healthy" if pct >= 85.0 else ("Moderate" if pct >= 75.0 else "Attention Required")

        # 3. Recent logs
        logs_sql = """
            SELECT sa.id, sa.date, sa.status, sa.check_in, sa.check_out, sa.working_hours, sa.source
            FROM staff_attendance sa
            WHERE sa.faculty_id = :entity_id AND sa.is_deleted = false
            ORDER BY sa.date DESC
            LIMIT 30
        """
        logs = self.execute_query(logs_sql, params={"entity_id": entity_id}, user_role=user_role)

        return {
            "member_id": user_info.get("id"),
            "full_name": user_info.get("full_name"),
            "email": user_info.get("email"),
            "role": user_info.get("role"),
            "total_days": tot,
            "attended_days": att,
            "absent_days": stats.get("absent_days", 0),
            "leave_days": stats.get("leave_days", 0),
            "attendance_pct": pct,
            "risk_status": risk,
            "recent_logs": logs
        }
