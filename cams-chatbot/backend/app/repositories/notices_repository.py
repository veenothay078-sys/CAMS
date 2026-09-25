from typing import Optional, Dict, Any, List
from app.repositories.base import BaseRepository

class NoticesRepository(BaseRepository):
    """Data access repository for official campus notices domain."""

    def list_published(self, user_role: str = "STUDENT", limit: int = 10) -> List[Dict[str, Any]]:
        sql = """
            SELECT n.title, n.body, n.category, n.priority, n.publish_date,
                   u.full_name AS published_by
            FROM notices n
            JOIN users u ON n.created_by = u.id
            WHERE n.is_deleted = false AND n.status = 'PUBLISHED'
            ORDER BY n.publish_date DESC
        """
        return self.execute_query(sql, user_role=user_role)
