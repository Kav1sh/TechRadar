CREATE TABLE repositories (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    github_id BIGINT NOT NULL UNIQUE,

    name TEXT NOT NULL,
    full_name TEXT NOT NULL UNIQUE,
    owner TEXT NOT NULL,

    description TEXT,
    url TEXT NOT NULL,
    language TEXT,

    created_at TIMESTAMPTZ NOT NULL,
    first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
SELECT current_user, current_database();

CREATE TABLE repository_metrics (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    repository_id BIGINT NOT NULL,
    observed_at TIMESTAMPTZ NOT NULL,

    stars BIGINT NOT NULL DEFAULT 0,
    forks BIGINT NOT NULL DEFAULT 0,
    open_issues BIGINT NOT NULL DEFAULT 0,

    contributors BIGINT,
    commits BIGINT,
    pull_requests BIGINT,
    releases BIGINT,

    CONSTRAINT fk_repository_metrics_repository
        FOREIGN KEY (repository_id)
        REFERENCES repositories(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_repository_metrics_repository_time
        UNIQUE (repository_id, observed_at),

    CONSTRAINT chk_repository_metrics_nonnegative
        CHECK (
            stars >= 0
            AND forks >= 0
            AND open_issues >= 0
        )
);

CREATE INDEX idx_repository_metrics_repository_time
    ON repository_metrics (repository_id, observed_at);

select * from repository_metrics;