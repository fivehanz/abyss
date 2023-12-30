from .base import *  # noqa
import os
# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get("DEBUG", True)

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "k2iau58dqh4b!^v$&eyi$zwt_*mawsc_dpn1w$xy9ha))-&pfz"

ALLOWED_HOSTS = ["*"]

INSTALLED_APPS += [  # noqa
    "django_sass",
]

EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

WAGTAIL_CACHE = False

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

try:
    from .local import *  # noqa
except ImportError:
    pass
