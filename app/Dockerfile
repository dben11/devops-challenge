# ============================================
# Stage 1: Builder — install dependencies
# ============================================
FROM python:3.12-slim AS builder

WORKDIR /build

# Copy only requirements first (layer caching!)
COPY requirements.txt .

# Install deps into a venv we can copy to the runtime stage
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# ============================================
# Stage 2: Runtime — minimal image
# ============================================
FROM python:3.12-slim AS runtime

# Create a non-root user
RUN groupadd --system app && \
    useradd --system --gid app --home /app --shell /sbin/nologin app

WORKDIR /app

# Copy the venv from builder stage (not pip cache, not build tools)
COPY --from=builder /opt/venv /opt/venv

# Copy application code (small, changes often — put last)
COPY app.py .

# Make the venv's binaries available
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8080

# Switch to non-root user
USER app

EXPOSE 8080

# Docker-native healthcheck (ECS can use this, ALB uses /health)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health').read()" || exit 1

# Use exec form so gunicorn receives SIGTERM directly (graceful shutdown)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "2", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
