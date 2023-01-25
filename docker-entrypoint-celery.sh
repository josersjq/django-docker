#!/bin/sh
cd /app/django_docker

/app/.venv/bin/celery -A config worker --concurrency=10 -l warning --beat
