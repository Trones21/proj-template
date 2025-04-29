"""
WSGI config for pk_projName project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/wsgi/
"""

import os
import logging
from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "tnow.settings")

try:
    application = get_wsgi_application()
    logging.getLogger("django").info("✅ Django WSGI app fully loaded and ready.")
except Exception:
    logging.getLogger("gunicorn.error").exception("🔥 Django WSGI app failed to start!")
    raise
