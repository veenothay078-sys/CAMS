from typing import List, Dict, Any, Optional, Literal
from pydantic import BaseModel, Field

class QueryPlan(BaseModel):
    """
    Formal QueryPlan abstraction.
    Represents what data needs to be retrieved without containing raw executable SQL.
    The Safe Query Layer remains solely responsible for constructing/validating the SQL.
    """
    intent: str = Field(..., description="Target intent name, e.g. attendance, marks, courses")
    domain: str = Field(..., description="Target CAMS data domain")
    tables: List[str] = Field(..., description="List of allowlisted CAMS tables to query")
    filters: Dict[str, Any] = Field(default_factory=dict, description="Query filters, e.g. student_id, semester, weekday")
    fields: List[str] = Field(default_factory=list, description="Fields/columns to project")
    output_type: Literal["summary", "table", "text", "clarification", "calculation", "chart"] = "summary"
    operation_type: Optional[Literal["average", "count", "minimum", "maximum", "percentage", "comparison", "trend", "grouping", "chart"]] = None
    chart_type: Optional[Literal["bar", "line", "pie"]] = None
    requires_clarification: bool = False
    clarification_prompt: Optional[str] = None
    target_entity: Optional[str] = None
