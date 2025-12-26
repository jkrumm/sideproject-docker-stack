# Multi-stage build with uv for fast dependency resolution
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

WORKDIR /app

# Clone the repository
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/jkrumm/free-planning-poker.git && \
    mv free-planning-poker/fpp-analytics/* . && \
    rm -rf free-planning-poker

# Install dependencies (cached layer)
RUN uv sync --frozen --no-dev --no-install-project

# Install the project itself
RUN uv sync --frozen --no-dev

# Production image
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"

# Copy application code
COPY --from=builder /app .

# Create data directory
RUN mkdir -p /app/data

EXPOSE 5100

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:5100/health').raise_for_status()"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5100", "--workers", "1", "--no-access-log"]