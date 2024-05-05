# Use an official Python runtime as a base image
FROM python:3.11.1

# Set the working directory in the container
WORKDIR /usr/src/app

# Install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# Clone the repository
RUN git clone https://github.com/jkrumm/free-planning-poker.git

# Set the working directory in the container to your app directory
WORKDIR /usr/src/app/free-planning-poker/analytics

# Pull the latest changes
RUN git pull

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5100

# Run app.py when the container launches
CMD ["gunicorn", "-b", "0.0.0.0:5100", "app:app"]