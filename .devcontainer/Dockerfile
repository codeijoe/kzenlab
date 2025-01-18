FROM debian:bookworm

# Update the package list and install systemd and udev
RUN apt update && apt install -y systemd udev

# Set the default command to start systemd
CMD ["/lib/systemd/systemd"]