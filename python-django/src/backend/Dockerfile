FROM python:3.12-slim

WORKDIR /app

# Install helpful debugging tools
RUN apt update && apt install -y \
    curl \
    net-tools \
    iputils-ping \
    procps \
    nano \
    && apt clean && rm -rf /var/lib/apt/lists/*

# (The apt clean & rm -rf reduces image size a little.)

# Copy app code
COPY --from=builder /app /app

ENV PATH=/root/.local/bin:$PATH
RUN pip install --upgrade pip && pip install gunicorn

ENV DJANGO_SETTINGS_MODULE=pk_projName.settings
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["gunicorn", "pk_projName.wsgi:application", "--bind", "0.0.0.0:8000"]
