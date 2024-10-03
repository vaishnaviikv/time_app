# Use Python 3.8-slim as the base image
FROM python:3.8-slim

# Update and clean up packages
RUN apt-get update \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a user group and user
RUN groupadd -g 799 nyu && \
    useradd -r -u 999 -g nyu nyu

# Set up the working directory
WORKDIR /app

# Install Flask and Gunicorn
RUN pip install Flask gunicorn

# Switch to the nyu user
USER nyu

# Copy the app's content to /app with ownership of nyu user
COPY --chown=nyu:nyu . .

# Use Gunicorn to serve the Flask app in production
CMD ["gunicorn", "-b", "0.0.0.0:8080", "run:app"]
