from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional
from app.core.config import settings
from app.core.logging import logger

class AnalysisServiceInterface(ABC):
    """Interface for isolated Python code execution and analytics via E2B Sandbox."""

    @abstractmethod
    async def perform_calculations(self, dataset: List[Dict[str, Any]], formula: str) -> Dict[str, Any]:
        """Executes statistical or mathematical analysis over a dataset."""
        pass


class ChartServiceInterface(ABC):
    """Interface for generating visualizations and charts via E2B Sandbox."""

    @abstractmethod
    async def generate_chart(self, dataset: List[Dict[str, Any]], chart_type: str, title: str) -> Dict[str, Any]:
        """Generates chart configuration or image artifact from query data."""
        pass


class E2BChartService(ChartServiceInterface, AnalysisServiceInterface):
    """
    E2B Sandbox integration stub for Phase 1.
    Prepared to connect to E2B Code Interpreter in Phase 2.
    """

    def __init__(self, api_key: str = settings.E2B_API_KEY):
        self.api_key = api_key

    async def perform_calculations(self, dataset: List[Dict[str, Any]], formula: str) -> Dict[str, Any]:
        logger.info(f"E2B Analysis requested (Phase 1 Stub) - items: {len(dataset)}")
        return {
            "status": "deferred_phase_2",
            "message": "E2B Code Interpreter calculation scheduled for Phase 2 integration."
        }

    async def generate_chart(self, dataset: List[Dict[str, Any]], chart_type: str, title: str) -> Dict[str, Any]:
        logger.info(f"E2B Chart requested (Phase 1 Stub) - type: {chart_type}, title: {title}")
        return {
            "status": "deferred_phase_2",
            "chart_type": chart_type,
            "title": title,
            "message": "E2B Sandbox visual rendering interface ready for Phase 2."
        }


def get_chart_service() -> ChartServiceInterface:
    return E2BChartService()
