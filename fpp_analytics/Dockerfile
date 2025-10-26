# Use an official Python runtime as a base image
FROM python:3.11.1

# Set the working directory in the container
WORKDIR /usr/src/app

# Install git and other package dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# Clone the repository
RUN git clone https://github.com/jkrumm/free-planning-poker.git

# Set the working directory in the container to your app directory
WORKDIR /usr/src/app/free-planning-poker/analytics

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5100 available to the world outside this container
EXPOSE 5100

# Run app.py when the container launches
# Using 2 workers with 2 threads each for low-traffic analytics app with background scheduler
# --max-requests restarts workers after 1000 requests to prevent memory leaks
CMD ["gunicorn", "-b", "0.0.0.0:5100", "--workers", "2", "--threads", "2", "--worker-class", "gthread", "--timeout", "120", "--max-requests", "1000", "--max-requests-jitter", "50", "app:app"]