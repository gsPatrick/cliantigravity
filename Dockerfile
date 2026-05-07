# Use a lightweight Debian image
FROM debian:bookworm-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download the specific Linux version (6.7.47) of CLIProxyAPI
RUN curl -L https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.47/CLIProxyAPI_6.7.47_linux_amd64.tar.gz -o cli-proxy.tar.gz \
    && tar -xzf cli-proxy.tar.gz \
    && find . -name "cli-proxy-api" -type f -exec mv {} . \; \
    && chmod +x cli-proxy-api \
    && rm -rf CLIProxyAPI* cli-proxy.tar.gz

# Copy local configuration and static files
COPY config.yaml .
COPY static/ ./static/

# Ensure the auth directory exists for persistence
RUN mkdir -p /root/.cli-proxy-api

# Expose the API port
EXPOSE 80

# Start the application
CMD ["./cli-proxy-api"]
