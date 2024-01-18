FROM python:3.11-slim-bookworm

# Add user that will be used in the container.
RUN useradd wagtail

# Set environment variables.
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable that is used by Gunicorn. This should match "EXPOSE"
#    command.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Port used by this container to serve HTTP.
EXPOSE 8000

# Install system packages required by Wagtail and Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    postgresql-client \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/* && apt-get clean

# Use /app folder as a directory where the source code is stored.
WORKDIR /app

# Copy the source code of the project into the container.
COPY --chown=wagtail:wagtail . .

# install granian server
RUN pip --no-cache-dir install granian

# Install the project requirements.
RUN pip --no-cache-dir install -r requirements.txt

# Set permissions for the wagtail user.
RUN chown wagtail:wagtail /app

# Use user "wagtail" to run the build commands below and the server itself.
USER wagtail

CMD exec granian \
    --interface wsgi abyss.wsgi:application \
    --host 0.0.0.0 \
    --port $PORT \
    --workers 2 \
    --http auto \
    --threading-mode runtime
