from .base import *  # noqa
from .base import env

# GENERAL
# ------------------------------------------------------------------------------
# https://docs.djangoproject.com/en/dev/ref/settings/#secret-key
SECRET_KEY = env("DJANGO_SECRET_KEY")
# https://docs.djangoproject.com/en/dev/ref/settings/#allowed-hosts
ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=["example.com"])


SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SECURE_HSTS_SECONDS = 60 * 60 * 24 * 30 * 6  # 180 days in seconds

# EMAIL
# ------------------------------------------------------------------------------
# https://docs.djangoproject.com/en/dev/ref/settings/#default-from-email
DEFAULT_FROM_EMAIL = env(
    "DJANGO_DEFAULT_FROM_EMAIL",
    default="Django Docker <noreply@example.com>",
)
# https://docs.djangoproject.com/en/dev/ref/settings/#server-email
SERVER_EMAIL = env("DJANGO_SERVER_EMAIL", default=DEFAULT_FROM_EMAIL)
# https://docs.djangoproject.com/en/dev/ref/settings/#email-subject-prefix
EMAIL_SUBJECT_PREFIX = env(
    "DJANGO_EMAIL_SUBJECT_PREFIX",
    default="[Django Docker]",
)

# AWS
# In production, these settings are required.
# The ECS task execution role will be used instead of
# `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
# AWS_REGION = env.str("AWS_DEFAULT_REGION")
# AWS_DEFAULT_REGION = AWS_REGION
# AWS_STORAGE_BUCKET_NAME = env("AWS_STORAGE_BUCKET_NAME")

# AWS_SES_REGION_NAME = "eu-west-1"
# AWS_SES_REGION_ENDPOINT = "email.eu-west-1.amazonaws.com"

# INSTALLED_APPS += [
#     "health_check.contrib.s3boto3_storage",
# ]
