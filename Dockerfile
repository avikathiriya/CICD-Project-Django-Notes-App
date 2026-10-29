FROM python:3.9-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app/backend

# Install system dependencies for mysqlclient and health checks
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc \
       default-libmysqlclient-dev \
       pkg-config \
       curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir mysqlclient

# Copy application code (secrets must be excluded by .dockerignore)
COPY . .

EXPOSE 8000

# Run the application with Gunicorn
CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]
