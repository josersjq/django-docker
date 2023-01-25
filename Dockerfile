FROM python:3.8-alpine as base

WORKDIR /app
COPY api /app

# hadolint ignore=DL3018
RUN apk add --no-cache postgresql-libs \
    && apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev postgresql-dev

# hadolint ignore=DL3013
RUN pip install --no-cache-dir poetry

FROM base as build

RUN python -m venv .venv && poetry install && apk --purge del .build-deps

FROM build as celery

COPY docker-entrypoint-celery.sh /docker-entrypoint-celery.sh
RUN chmod +x /docker-entrypoint-celery.sh

FROM build as dev

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV DJANGO_SETTINGS_MODULE=config.local

FROM base as production

RUN python -m venv .venv && poetry install --no-root && apk --purge del .build-deps

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV DJANGO_SETTINGS_MODULE=config.production

EXPOSE 5000

ENTRYPOINT ["/docker-entrypoint.sh"]

