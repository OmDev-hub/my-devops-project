# ---- Base Stage ----
# Use an official Python runtime as a parent image.
# The 'slim' version is a good practice as it's smaller than the full version.
FROM python:3.11-slim

# Set the working directory inside the container to /app.
# This is where our application code will live.
WORKDIR /app

# ---- Dependency Stage ----
# Copy the dependency list first.
# This is a key optimization for Docker layer caching. If requirements.txt
# doesn't change, Docker will use the cached layer from a previous build
# and not reinstall all the packages, making subsequent builds much faster.
COPY requirements.txt .

# Install the Python dependencies.
# --no-cache-dir ensures we don't store the download cache, keeping the image smaller.
RUN pip install --no-cache-dir -r requirements.txt

# ---- Application Stage ----
# Now, copy the rest of the application source code into the container at /app.
COPY . .

# Inform Docker that the container listens on port 5000 at runtime.
# This is metadata and does not actually publish the port.
EXPOSE 5000

# Define the command to run your application.
# This is the command that will be executed when the container starts.
# We use the exec form (a JSON array) which is the preferred way.
CMD ["python3", "app.py"]