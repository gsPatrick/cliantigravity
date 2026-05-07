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
# This replaces the Windows version provided in the local folder
RUN curl -L https://github.com/router-for-me/CLIProxyAPI/releases/download/v6.7.47/CLIProxyAPI_6.7.47_linux_amd64.tar.gz -o cli-proxy.tar.gz \
    && tar -xzf cli-proxy.tar.gz --strip-components=1 \
    && rm cli-proxy.tar.gz

# Copy local configuration and static files
# Note: config.yaml has been updated to use 0.0.0.0
COPY config.yaml .
COPY static/ ./static/

# Ensure the auth directory exists for persistence
RUN mkdir -p /root/.cli-proxy-api

# Expose the API port
EXPOSE 80

# Start the application
CMD ["./cli-proxy-api"]
