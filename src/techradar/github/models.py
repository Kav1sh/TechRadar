from dataclasses import dataclass
from datetime import datetime


@dataclass
class GitHubRepository:
    github_id: int
    name: str
    full_name: str
    owner: str
    description: str | None
    url: str
    language: str | None
    created_at: datetime

@dataclass
class GitHubMetrics:
    stars: int
    forks: int
    open_issues: int
    observed_at: datetime
    