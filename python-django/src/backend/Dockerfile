# Stage 1: Build the Application (Using Python Image)
FROM python:3.12-slim AS builder

WORKDIR /app

# Pre-copy/cache requirements for better docker layer caching
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install --user -r requirements.txt

# Copy the source code
COPY . .

# (Optional) Collect static files if Django uses them
RUN python manage.py collectstatic --noinput

# Stage 2: Create the Final Clean Image
FROM debian:12

WORKDIR /dist

# Install minimal necessary tools
RUN apt update && apt install -y curl net-tools iputils-ping procps nano python3 python3-pip

# Copy application files from builder
COPY --from=builder /app /dist

# Install runtime dependencies (again, usually production deps only)
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install -r requirements.txt

# Set environment variables (you can move these to docker-compose too)
ENV DJANGO_SETTINGS_MODULE=your_project.settings
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

