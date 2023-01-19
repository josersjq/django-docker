#!/bin/bash
cd /app

/app/.venv/bin/python manage.py migrate
/app/.venv/bin/python manage.py collectstatic --noinput --ignore=*.scss

/app/.venv/bin/gunicorn --worker-class=uvicorn.workers.UvicornWorker piedpiper.asgi:application -b=0.0.0.0:5000 --workers=10