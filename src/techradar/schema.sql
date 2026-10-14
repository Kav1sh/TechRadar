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
select * from repositories;

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
    4291595,
    'fastapi',
    'fastapi/fastapi',
    'fastapi',
    'FastAPI framework, high performance, easy to learn, fast to code, ready for production.',
    'https://github.com/fastapi/fastapi',
    'Python',
    '2018-12-08T08:30:00Z'
);

INSERT INTO repository_metrics (
    repository_id,
    observed_at,
    stars,
    forks,
    open_issues
)
VALUES (
    1,
    NOW(),
    0,
    0,
    0
);

select r.id,r.full_name,m.observed_at,m.stars,m.forks,m.open_issues from repositories as r left join repository_metrics as m on r.id=m.repository_id;

INSERT INTO repository_metrics (
    repository_id,
    observed_at,
    stars,
    forks,
    open_issues
)
VALUES (
    1,
    NOW() + INTERVAL '1 day',
    1000,
    100,
    20
);


SELECT
    r.full_name,
    m.observed_at,
    m.stars,
    m.forks,
    m.open_issues
FROM repositories AS r
JOIN repository_metrics AS m
    ON r.id = m.repository_id
ORDER BY m.observed_at;
SELECT
    r.full_name,
    m.observed_at,
    m.stars,
    m.forks,
    m.open_issues
FROM repositories AS r
JOIN repository_metrics AS m
    ON r.id = m.repository_id
ORDER BY m.observed_at;
TRUNCATE TABLE repository_metrics, repositories RESTART IDENTITY CASCADE;
select * from repositories;
truncate table repository_metrics,repositories;
cascade table repositories;