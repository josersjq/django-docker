FROM python:3.8

WORKDIR /app
COPY api /app
RUN pip install poetry
RUN python -m venv .venv && poetry install --no-root

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
