# These threads helped a lot to run GTK from Docker: 
# https://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0
# https://github.com/sickcodes/Docker-OSX/issues/106

FROM rust:latest

RUN apt update && apt install -y libwebkit2gtk-4.0-dev \
    build-essential \
    curl \
    wget \
    libssl-dev \
    libgtk-3-dev \
    # libappindicator3-dev \ # not found!
    patchelf \
    librsvg2-dev

RUN mkdir -m a=rwx /cargo
ENV CARGO_HOME=/cargo

RUN cargo install tauri-cli --locked --version ^1.0.0-beta

# dirty workaround: cargo creates folders that belong to the container root user
# thus, when running the container with our host user, it fails because of permissions
RUN chmod -R 777 /cargo
