import requests
from datetime import datetime, timezone


from techradar.github.models import GitHubRepository, GitHubMetrics


class GitHubClient:
    BASE_URL = "https://api.github.com"

    def get_repository(self, owner: str, repo: str) -> dict:
        url = f"{self.BASE_URL}/repos/{owner}/{repo}"

        response = requests.get(url, timeout=10)
        response.raise_for_status()

        return response.json()

    def parse_repository(self, data: dict) -> GitHubRepository:
        return GitHubRepository(
            github_id=data["id"],
            name=data["name"],
            full_name=data["full_name"],
            owner=data["owner"]["login"],
            description=data["description"],
            url=data["html_url"],
            language=data["language"],
            created_at=datetime.fromisoformat(
                data["created_at"].replace("Z", "+00:00")
            ),
        )
    def parse_metrics(self,data:dict) -> GitHubMetrics:
        return GitHubMetrics(
            stars=data["stargazers_count"],
            forks=data["forks_count"],
            open_issues=data["open_issues_count"],
            observed_at=datetime.now(timezone.utc),
        )