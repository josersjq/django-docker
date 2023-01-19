FROM python:3.8

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpng-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libpq-dev \
  libssl-dev \
  pkg-config

WORKDIR /app
COPY api /app
RUN pip install poetry
RUN python -m venv .venv && poetry install --no-root

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
