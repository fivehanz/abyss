#!/usr/bin/env python3

import os
import subprocess

# Set the Django project directory
DJANGO_PROJECT_DIR = '/path/to/your/django/project'

# Change the current working directory to the Django project directory
os.chdir(DJANGO_PROJECT_DIR)

# Run `python manage.py collectstatic --noinput`
subprocess.run(['python', 'manage.py', 'collectstatic', '--noinput'], check=True)

# Run Django compressor
subprocess.run(['python', 'manage.py', 'compress'], check=True)
