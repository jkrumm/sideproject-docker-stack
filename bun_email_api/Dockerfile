FROM oven/bun

# Clean up the cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# clean up the working directory
RUN rm -rf /usr/src/app

WORKDIR /usr/src/app

# Install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# Clone the repository
RUN git clone https://github.com/jkrumm/bun-email-api.git

# Set the working directory in the container to your app directory
WORKDIR /usr/src/app/bun-email-api

# Pull the latest changes
RUN git pull

# Install any needed packages
RUN bun install

# Set the environment variables
ENV NODE_ENV production

# Make port 3010 available to the world outside this container
EXPOSE 3010

# Run the app
CMD ["bun", "run", "src/index.ts"]

