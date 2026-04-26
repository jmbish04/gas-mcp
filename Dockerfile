# Use Node 22 slim image for smaller footprint
FROM node:22-slim

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the MCP server code
COPY . .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app \
    && mkdir -p /home/app/.config/google-apps-script-mcp \
    && chown -R app:app /app /home/app
USER app

# Set environment variables
ENV NODE_ENV=production
ENV HOME=/home/app

# Default command - MCP server typically runs with stdio transport
CMD ["node", "mcpServer.js"]
