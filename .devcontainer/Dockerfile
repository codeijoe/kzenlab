FROM debian:bookworm

# Update the package list and install systemd and udev
RUN apt update && apt install -yqq \
    systemd \
    udev \
    cmake \
    curl \
    wget
    vim \
    htop \
    udisks2

# Create a non-root user
#RUN useradd -m -s /bin/bash vscode && \
#    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode && \
 #   chmod 0440 /etc/sudoers.d/vscode

# Switch to the non-root user
#USER vscode

# Set the working directory
WORKDIR /workspace

# Set the default command to start systemd
CMD ["/lib/systemd/systemd"]