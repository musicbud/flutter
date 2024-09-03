# Use a more recent Flutter image
FROM cirrusci/flutter:3.13.9

# Set the working directory in the container
WORKDIR /app

# Copy the rest of the application code
COPY . .

# Get the dependencies
RUN flutter pub get

# Build the app for the web
RUN flutter build web

# Command to run the app
CMD ["flutter", "run", "--release"]
