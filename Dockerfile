FROM python:3.8-alpine as base

WORKDIR /app
COPY api/poetry.toml /app/poetry.toml
COPY api/poetry.lock /app/poetry.lock
COPY api/pyproject.toml /app/pyproject.toml

# hadolint ignore=DL3018
RUN apk add --no-cache --virtual .build-deps \
    gcc musl-dev libffi-dev postgresql-dev

# hadolint ignore=DL3013
RUN pip install --no-cache-dir poetry && \
    python -m venv .venv && \
    poetry install --no-root && \
    apk --purge del .build-deps

FROM python:3.8-alpine as build

WORKDIR /app
COPY api/ /app

# hadolint ignore=DL3018
RUN apk add --no-cache postgresql-libs

COPY --from=base /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=base /usr/local/bin/ /usr/local/bin/
COPY --from=base /app/.venv/ /app/.venv/

FROM build as celery

COPY docker-entrypoint-celery.sh /docker-entrypoint-celery.sh
RUN chmod +x /docker-entrypoint-celery.sh

FROM build as dev

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV DJANGO_SETTINGS_MODULE=config.local

FROM build as production

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV DJANGO_SETTINGS_MODULE=config.production

EXPOSE 5000

ENTRYPOINT ["/docker-entrypoint.sh"]

