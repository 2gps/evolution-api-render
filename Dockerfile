# Evolution API for Render.com
# Uses the official Docker image

FROM evoapicloud/evolution-api:latest

# Expose the default port
EXPOSE 8080

# The official image already has the entrypoint
# Environment variables will be set in Render dashboard
