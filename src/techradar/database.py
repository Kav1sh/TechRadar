from sqlalchemy import create_engine, text

from techradar.config import DATABASE_URL

engine = create_engine(DATABASE_URL)

def save_repository_metrics(repository_id, metrics):
    query = text("""
        INSERT INTO repository_metrics (
            repository_id,
            observed_at,
            stars,
            forks,
            open_issues
        )
        VALUES (
            :repository_id,
            :observed_at,
            :stars,
            :forks,
            :open_issues
        )
        RETURNING id
    """)

    with engine.begin() as connection:
        result = connection.execute(
            query,
            {
                "repository_id": repository_id,
                "observed_at": metrics.observed_at,
                "stars": metrics.stars,
                "forks": metrics.forks,
                "open_issues": metrics.open_issues,
            },
        )

        return result.scalar_one()


def save_repository(repository):
    query = text("""
        INSERT INTO repositories (
            github_id,
            name,
            full_name,
            owner,
            description,
            url,
            language,
            created_at
        )
        VALUES (
            :github_id,
            :name,
            :full_name,
            :owner,
            :description,
            :url,
            :language,
            :created_at
        )
        ON CONFLICT (github_id)
        DO UPDATE SET
            name = EXCLUDED.name,
            full_name = EXCLUDED.full_name,
            owner = EXCLUDED.owner,
            description = EXCLUDED.description,
            url = EXCLUDED.url,
            language = EXCLUDED.language,
            last_seen_at = NOW()
        RETURNING id
    """)

    with engine.begin() as connection:
        result = connection.execute(
            query,
            {
                "github_id": repository.github_id,
                "name": repository.name,
                "full_name": repository.full_name,
                "owner": repository.owner,
                "description": repository.description,
                "url": repository.url,
                "language": repository.language,
                "created_at": repository.created_at,
            },
        )

        return result.scalar_one()
