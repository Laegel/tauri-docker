# Tauri with Docker (POC)

An attempt to make Tauri run from a Docker container.

This image is not meant to handle the frontend and its devtools: **only the core** (Rust) part.\
If you need a full app to work with Docker, you'll need to use Compose to have the core and the frontend as separate images.

This image provides a ready-to-use Tauri CLI (built from Cargo) for Debian-based systems.

## Setup

Assuming you already have Git and Docker installed.

Clone the repo, get in there, then build the image:

```sh
docker build -t tauri .
```

## Usage

Because of GTK (a GUI software), we need to add some more flags to run Tauri properly, which make it quite verbose:

```sh
docker run --rm -v `pwd`:/app -w /app -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" --user "$(id -u):$(id -g)" -it tauri cargo tauri --help
```

### Command Explainations

```-v `pwd`:/app -w /app``` flags are used to link your current working directory to the container `/app` dir.\
Whatever happens there, happens to your current dir.

```-v /tmp/.X11-unix:/tmp/.X11-unix``` is required to make your container communicate with your host X11 server.

```-e "DISPLAY=${DISPLAY:-:0.0}"``` another flag to run a GUI from Docker, we need to set it explicitly.

```--user "$(id -u):$(id -g)"``` allows us to run the container with our current host user, to avoid files permissions issues.

### Aliasing

To avoid mistakes, you'd better create an alias like this for your profile:

```bash
alias tauri='docker run --rm -v `pwd`:/app -w /app -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" --user "$(id -u):$(id -g)" -it tauri cargo tauri '
```

Then, simply run your commands (see [here](https://tauri.studio/docs/api/cli) for more details)!

## Try it!

In this repo, start with `tauri init` and answer the questions with "Test", "Test", "../frontend" and "../frontend".

Next run `tauri dev`, wait for everything to download then the GUI should open on https://tauri.studio.

## Troubleshoot

I may have forgotten some steps to make it work, here are a few leads:

- run `xhost local:root` to make sure your host can open a GUI from your container.
- I've removed `--net=host` flag when running the container because it didn't look mandatory.

## Known Issues

When running the `dev` command, killing the container will stop the GUI but not the whole process (but closing the GUI does).

## Next Steps

- Make sure nothing weird happens/breaks
- Try to build
- Have a better way to handle permissions
- Provide a docker-compose.yml sample
- Support more systems
