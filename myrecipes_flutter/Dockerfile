#Stage 1 - Install dependencies and build the app
FROM debian:latest AS requirements

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

FROM requirements AS env
# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
# Enable flutter web
RUN flutter channel beta
RUN flutter upgrade
RUN flutter config --enable-web

FROM env as build-env
ARG API_BASE_URL=https://at-myrecipe-server.azurewebsites.net
ARG ENVIRONMENT=Staging
ARG ALLOW_BAD_CERTIFICATE=false
# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web --dart-define=API_BASE_URL=${API_BASE_URL} --dart-define=ENVIRONMENT=${ENVIRONMENT} --dart-define=ALLOW_BAD_CERTIFICATE=${ALLOW_BAD_CERTIFICATE}

# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html