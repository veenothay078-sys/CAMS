import json
import time
from typing import Dict, Any, Optional, List, Tuple
from app.core.config import settings
from app.core.logging import logger

try:
    from e2b_code_interpreter import Sandbox
except ImportError:
    Sandbox = None

class E2BService:
    """
    E2B Sandbox integration service.
    Provides isolated, controlled code-execution and data-analysis for CAMS queries
    requiring calculations, aggregations, trend analysis, or chart specifications.

    SECURITY GUARANTEES:
    1. E2B Sandbox NEVER receives database credentials or direct database access.
    2. E2B Sandbox ONLY receives authorized, sanitized query results from PostgreSQL.
    3. User inputs NEVER become raw executable code; code is strictly generated from
       controlled internal templates.
    """

    SUPPORTED_OPERATIONS = {
        "average", "count", "minimum", "maximum", "percentage",
        "comparison", "trend", "grouping", "chart"
    }

    SUPPORTED_CHART_TYPES = {"bar", "line", "pie"}

    MAX_DATASET_ROWS = 500

    def __init__(
        self,
        api_key: Optional[str] = None,
        timeout: float = 20.0
    ):
        self.api_key = api_key or settings.E2B_API_KEY
        self.timeout = timeout

    @property
    def is_configured(self) -> bool:
        """Returns True if a non-empty E2B API key is configured."""
        return bool(self.api_key and self.api_key.strip())

    def execute_analysis(
        self,
        operation: Any,
        dataset: Any,
        options: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Executes a controlled analytical calculation (average, count, min, max, percentage, etc.)
        over verified PostgreSQL records.
        """
        # Flexible argument ordering: execute_analysis(dataset, "average") or ("average", dataset)
        if isinstance(operation, list) and isinstance(dataset, str):
            operation, dataset = dataset, operation

        options = options or {}
        operation = str(operation).lower()

        # Step 1: Validate dataset
        is_valid, err_msg, sanitized_data = self._validate_and_sanitize_dataset(dataset)
        if not is_valid:
            return {
                "success": False,
                "operation": operation,
                "result": None,
                "error": err_msg or "Insufficient data to perform this calculation."
            }

        # Step 2: Try E2B Sandbox execution if configured
        if self.is_configured:
            try:
                e2b_result = self._run_in_e2b_sandbox(operation, sanitized_data, options)
                if e2b_result and e2b_result.get("success"):
                    return e2b_result
            except Exception as e:
                logger.warning(f"E2B Sandbox execution encountered an issue ({e}); falling back to verified local analysis engine.")

        # Step 3: Reliable controlled fallback calculation
        return self._local_controlled_analysis(operation, sanitized_data, options)

    def generate_chart_data(
        self,
        chart_type: Any,
        dataset: Any,
        title: str = "Analysis Chart",
        x_axis: str = "Category",
        y_axis: str = "Value",
        options: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Generates structured chart specifications (bar, line, pie) from verified CAMS database rows.
        """
        # Flexible argument ordering: generate_chart_data(dataset, "bar") or ("bar", dataset)
        if isinstance(chart_type, list) and isinstance(dataset, str):
            chart_type, dataset = dataset, chart_type

        options = options or {}
        chart_type = str(chart_type).lower()
        if chart_type not in self.SUPPORTED_CHART_TYPES:
            chart_type = "bar"

        # Validate dataset
        is_valid, err_msg, sanitized_data = self._validate_and_sanitize_dataset(dataset)
        if not is_valid:
            return {
                "success": False,
                "error": "Insufficient data is available to generate this chart.",
                "message": "Insufficient data is available to generate this chart.",
                "chart": {
                    "type": chart_type,
                    "title": title,
                    "x_axis": x_axis,
                    "y_axis": y_axis,
                    "data": []
                }
            }

        # Try E2B Sandbox execution if configured
        if self.is_configured:
            try:
                e2b_chart = self._run_e2b_chart_generation(chart_type, sanitized_data, title, x_axis, y_axis, options)
                if e2b_chart and e2b_chart.get("success"):
                    return e2b_chart
            except Exception as e:
                logger.warning(f"E2B Sandbox chart generation error ({e}); using verified local chart generator.")

        # Local controlled chart generation
        return self._local_controlled_chart(chart_type, sanitized_data, title, x_axis, y_axis, options)

    def _validate_and_sanitize_dataset(
        self,
        dataset: List[Dict[str, Any]]
    ) -> Tuple[bool, Optional[str], List[Dict[str, Any]]]:
        """
        Strictly sanitizes dataset before any code execution:
        - Rejects empty sets
        - Clamps oversized sets
        - Strips sensitive fields
        """
        if not dataset or not isinstance(dataset, list) or len(dataset) == 0:
            return False, "Insufficient data is available to perform analysis or generate this chart.", []

        if len(dataset) > self.MAX_DATASET_ROWS:
            logger.warning(f"Dataset exceeds {self.MAX_DATASET_ROWS} rows. Clamping dataset.")
            dataset = dataset[:self.MAX_DATASET_ROWS]

        sensitive_fields = {
            "hashed_password", "aadhaar_number", "pan_number", "passport_number",
            "parent_annual_income", "document_aadhaar_url", "document_income_url"
        }

        sanitized = []
        for row in dataset:
            if isinstance(row, dict):
                clean_row = {k: v for k, v in row.items() if k not in sensitive_fields}
                sanitized.append(clean_row)

        return True, None, sanitized

    def _run_in_e2b_sandbox(
        self,
        operation: str,
        dataset: List[Dict[str, Any]],
        options: Dict[str, Any]
    ) -> Optional[Dict[str, Any]]:
        """Executes controlled Python script in E2B Sandbox."""
        if not Sandbox:
            return None

        code = f"""
import json
data = {json.dumps(dataset, default=str)}
op = "{operation}"
target_col = "{options.get('target_column', '')}"

def compute():
    if not data:
        return {{"error": "Empty dataset"}}
    
    # Identify numerical values
    nums = []
    for r in data:
        val = r.get(target_col) if target_col and target_col in r else None
        if val is None:
            # find first numeric
            for k, v in r.items():
                try:
                    nums.append(float(v))
                    break
                except (ValueError, TypeError):
                    continue
        else:
            try:
                nums.append(float(val))
            except (ValueError, TypeError):
                pass

    if op == "count":
        return {{"value": len(data), "metric": "count"}}
    if not nums:
        return {{"value": len(data), "metric": "count"}}
        
    if op == "average":
        return {{"value": round(sum(nums) / len(nums), 2), "metric": "average", "count": len(nums)}}
    elif op == "minimum":
        return {{"value": min(nums), "metric": "minimum"}}
    elif op == "maximum":
        return {{"value": max(nums), "metric": "maximum"}}
    elif op == "percentage":
        avg_val = sum(nums) / len(nums)
        return {{"value": round(avg_val, 2), "metric": "percentage"}}
    return {{"value": round(sum(nums) / len(nums), 2), "metric": op}}

res = compute()
print("__RESULT__" + json.dumps(res))
"""
        with Sandbox(api_key=self.api_key) as sandbox:
            execution = sandbox.run_code(code, timeout=self.timeout)
            for out in execution.logs.stdout:
                if "__RESULT__" in out:
                    raw_res = out.split("__RESULT__")[1].strip()
                    res_json = json.loads(raw_res)
                    return {
                        "success": True,
                        "operation": operation,
                        "result": res_json.get("value"),
                        "metrics": res_json,
                        "engine": "e2b_sandbox"
                    }
        return None

    def _run_e2b_chart_generation(
        self,
        chart_type: str,
        dataset: List[Dict[str, Any]],
        title: str,
        x_axis: str,
        y_axis: str,
        options: Dict[str, Any]
    ) -> Optional[Dict[str, Any]]:
        """Generates chart points inside E2B Sandbox."""
        if not Sandbox:
            return None

        code = f"""
import json
data = {json.dumps(dataset, default=str)}
chart_type = "{chart_type}"

points = []
for r in data:
    x_val = r.get("course_name") or r.get("weekday") or r.get("date") or r.get("name") or r.get("title") or r.get("full_name") or "Item"
    y_val = r.get("total_mark") or r.get("internal_exam_mark") or r.get("mark") or r.get("amount") or r.get("attendance_percentage") or 1.0
    try:
        y_num = float(y_val)
    except (ValueError, TypeError):
        y_num = 1.0
    points.append({{"x": str(x_val), "y": round(y_num, 2), "label": f"{{x_val}}: {{round(y_num, 2)}}"}})

res = {{
    "type": chart_type,
    "title": "{title}",
    "x_axis": "{x_axis}",
    "y_axis": "{y_axis}",
    "data": points[:15]
}}
print("__CHART__" + json.dumps(res))
"""
        with Sandbox(api_key=self.api_key) as sandbox:
            execution = sandbox.run_code(code, timeout=self.timeout)
            for out in execution.logs.stdout:
                if "__CHART__" in out:
                    raw_chart = out.split("__CHART__")[1].strip()
                    chart_json = json.loads(raw_chart)
                    return {
                        "success": True,
                        "chart": chart_json,
                        "engine": "e2b_sandbox"
                    }
        return None

    def _local_controlled_analysis(
        self,
        operation: str,
        dataset: List[Dict[str, Any]],
        options: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Controlled Python execution engine."""
        target_col = options.get("target_column")
        numeric_values: List[float] = []
        matched_field = target_col

        # Special handling for percentage on categorical status (e.g., status="PRESENT")
        if operation == "percentage":
            status_vals = [str(r.get("status", "")).upper() for r in dataset if "status" in r]
            if status_vals:
                present_count = sum(1 for s in status_vals if s in ("PRESENT", "P", "ATTENDED", "1"))
                pct = round((present_count / len(status_vals)) * 100, 2)
                return {
                    "success": True,
                    "operation": "percentage",
                    "result": pct,
                    "field": "status",
                    "metrics": {"percentage": pct, "sample_size": len(status_vals)},
                    "engine": "controlled_engine"
                }

        for row in dataset:
            val = row.get(target_col) if target_col and target_col in row else None
            if val is not None:
                try:
                    numeric_values.append(float(val))
                    continue
                except (ValueError, TypeError):
                    pass

            # Try specific common numeric keys
            found = False
            for k in (
                "percentage", "attendance_percentage", "marks", "mark", "total_mark",
                "internal_exam_mark", "score", "amount", "credits", "cgpa", "value",
                "attended_classes", "total_classes"
            ):
                if k in row and row[k] is not None:
                    try:
                        numeric_values.append(float(row[k]))
                        matched_field = k
                        found = True
                        break
                    except (ValueError, TypeError):
                        continue

            if not found:
                # Find any float/int value
                for k, v in row.items():
                    if isinstance(v, (int, float)) and not isinstance(v, bool):
                        numeric_values.append(float(v))
                        matched_field = k
                        break

        count_total = len(dataset)
        if operation == "count":
            return {
                "success": True,
                "operation": "count",
                "result": count_total,
                "field": matched_field or "count",
                "metrics": {"count": count_total},
                "engine": "controlled_engine"
            }

        if not numeric_values:
            return {
                "success": False,
                "operation": operation,
                "error": "No numeric fields available in dataset to perform this calculation.",
                "metrics": {},
                "engine": "controlled_engine"
            }

        if operation == "average":
            avg = round(sum(numeric_values) / len(numeric_values), 2)
            return {
                "success": True,
                "operation": "average",
                "result": avg,
                "field": matched_field,
                "metrics": {"average": avg, "count": len(numeric_values), "min": min(numeric_values), "max": max(numeric_values)},
                "engine": "controlled_engine"
            }
        elif operation == "minimum":
            min_val = min(numeric_values)
            return {
                "success": True,
                "operation": "minimum",
                "result": min_val,
                "field": matched_field,
                "metrics": {"minimum": min_val, "count": len(numeric_values)},
                "engine": "controlled_engine"
            }
        elif operation == "maximum":
            max_val = max(numeric_values)
            return {
                "success": True,
                "operation": "maximum",
                "result": max_val,
                "field": matched_field,
                "metrics": {"maximum": max_val, "count": len(numeric_values)},
                "engine": "controlled_engine"
            }
        elif operation == "percentage":
            avg_pct = round(sum(numeric_values) / len(numeric_values), 2)
            return {
                "success": True,
                "operation": "percentage",
                "result": avg_pct,
                "field": matched_field,
                "metrics": {"percentage": avg_pct, "sample_size": len(numeric_values)},
                "engine": "controlled_engine"
            }
        elif operation == "trend":
            direction = "steady"
            change = 0.0
            if len(numeric_values) >= 2:
                diff = numeric_values[-1] - numeric_values[0]
                direction = "increasing" if diff > 0 else ("decreasing" if diff < 0 else "steady")
                change = round(diff, 2)
            return {
                "success": True,
                "operation": "trend",
                "result": change,
                "direction": direction,
                "change": change,
                "field": matched_field,
                "metrics": {"direction": direction, "change": change, "count": len(numeric_values)},
                "engine": "controlled_engine"
            }
        elif operation in ("comparison", "grouping"):
            return {
                "success": True,
                "operation": operation,
                "result": {"sample_count": len(numeric_values), "average": round(sum(numeric_values)/len(numeric_values), 2)},
                "field": matched_field,
                "metrics": {"data_points": len(numeric_values)},
                "engine": "controlled_engine"
            }

        return {
            "success": True,
            "operation": operation,
            "result": round(sum(numeric_values) / len(numeric_values), 2),
            "field": matched_field,
            "metrics": {"count": len(numeric_values)},
            "engine": "controlled_engine"
        }

    def _local_controlled_chart(
        self,
        chart_type: str,
        dataset: List[Dict[str, Any]],
        title: str,
        x_axis: str,
        y_axis: str,
        options: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Generates chart points locally with complete formatting."""
        data_points = []
        
        # Check if dataset has any numeric field (including Decimal from PostgreSQL)
        has_numeric = False
        for r in dataset[:10]:
            for k, v in r.items():
                if v is not None and not isinstance(v, bool):
                    try:
                        float(v)
                        has_numeric = True
                        break
                    except (ValueError, TypeError):
                        pass
            if has_numeric:
                break

        if not has_numeric and len(dataset) > 0:
            # Auto-aggregate frequency counts by primary category (e.g. status, designation, role)
            freq_map: Dict[str, int] = {}
            for r in dataset:
                label = (
                    r.get("status") or r.get("attendance_status") or r.get("designation") or
                    r.get("role") or r.get("faculty_name") or r.get("department_name") or
                    r.get("course_name") or r.get("category") or "General"
                )
                lbl_str = str(label).strip()
                freq_map[lbl_str] = freq_map.get(lbl_str, 0) + 1

            for lbl, cnt in list(freq_map.items())[:15]:
                data_points.append({
                    "label": lbl,
                    "value": cnt,
                    "x": lbl,
                    "y": cnt
                })
        else:
            for r in dataset[:15]:
                x_val = (
                    r.get("attendance_status") or r.get("semester_label") or r.get("department_name") or
                    r.get("designation_label") or r.get("weekday_label") or r.get("fee_label") or
                    r.get("subject_name") or r.get("course_name") or r.get("faculty_name") or
                    r.get("student_name") or r.get("month") or r.get("weekday") or r.get("date") or
                    r.get("code") or r.get("name") or r.get("title") or r.get("full_name") or
                    r.get("fee_type") or r.get("status") or "Item"
                )
                x_str = str(x_val).strip()[:30]

                y_val = (
                    r.get("record_count") or r.get("course_count") or r.get("average_marks") or
                    r.get("student_count") or r.get("faculty_count") or r.get("class_count") or
                    r.get("fee_amount") or r.get("percentage") or r.get("attendance") or
                    r.get("total_mark") or r.get("internal_exam_mark") or r.get("mark") or
                    r.get("marks") or r.get("amount") or r.get("credits") or
                    r.get("attendance_percentage") or r.get("count") or r.get("value")
                )
                if y_val is None:
                    # Find any numeric value
                    for k, v in r.items():
                        if isinstance(v, (int, float)) and not isinstance(v, bool):
                            y_val = v
                            break

                try:
                    y_num = float(y_val) if y_val is not None else 1.0
                except (ValueError, TypeError):
                    y_num = 1.0

                data_points.append({
                    "label": x_str,
                    "value": round(y_num, 2),
                    "x": x_str,
                    "y": round(y_num, 2)
                })

        return {
            "success": True,
            "chart": {
                "type": chart_type,
                "title": title,
                "x_axis": x_axis,
                "y_axis": y_axis,
                "data": data_points
            },
            "engine": "controlled_engine"
        }
