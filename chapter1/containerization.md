Containerization
================

This is the short version. A Container is just the tech buzzword for what you
can think of as a "virtual computer."

Docker/Podman (which basically I am going to use interchangeably as far as casual
nomenclature is concerned) solve the following problem:

When we have a data analysis it has to take place in a specific _context_. It needs
software libraries installed, basically. And these setups can be quite elaborate
and even brittle. Before containers we'd pass around complicated documents
describing exactly how to get a system configured to do an analysis.

You'd try to do this, but then you'd make a mistake halfway through and that would
break your system or leave it in a weird state without any easy way to undo
it. Maybe you'd get it working but it wouldn't give the same results, etc, etc.

It sucks.

Containers allow us to _describe_ the environment we need to do an analysis. The
system then _builds_ that environment (or pulls it from the cloud) and we work
in that container. This has huge benefits. If we screw up our Container it's no
big deal. We can throw it away and rebuild it. It also protects our host operating
system from any messes we might make in the container.

Using containers we can maintain separate environments for each project, even.
This is a huge improvement. 

Docker is the biggest commercial container system, so we call these files that 
describe our system "Dockerfiles". A simple Dockerfile might look like this:

```Dockerfile 
FROM rocker/verse

RUN R -e "install.packages('plotly')"

```

The Dockerfile (also called a Containerfile if you want to stick it to the man)
for this book looks like this:

```Dockerfile file="/fs/book/nvidia.Containerfile"
FROM docker.io/nvidia/cuda:12.9.0-devel-ubuntu22.04
#FROM docker.io/nvidia/cuda:12.8.0-devel-ubuntu22.04

# Run as root
USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# System setup
RUN apt-get update && \
    apt-get install -y locales wget && \
    locale-gen en_US.UTF-8

# Add CRAN PPA for modern R
RUN apt update && apt-get install -y software-properties-common dirmngr && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/cran.gpg && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" && \
    apt-get update

# Install base tools and dependencies
RUN apt update && apt-get install -y \
    r-base r-base-dev \
    build-essential libcurl4-openssl-dev libssl-dev libxml2-dev \
    libgit2-dev libjpeg-dev libpng-dev libtiff5-dev libglib2.0-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libfontconfig1-dev \
    libx11-dev libxext-dev libxt-dev libxrender-dev libxpm-dev libxft-dev \
    libgtk-3-dev libncurses-dev libxrandr-dev libxinerama-dev \
    libmagickwand-dev libgnutls28-dev libjansson-dev \
    wget curl ca-certificates sudo bash python3 python3-pip ttyd apt-utils python3-venv libgccjit-10-dev gcc-10 libgif-dev libjansson-dev && \
    apt-get install -y \
    git \  
    build-essential \
    libgtk-3-dev \
    libgnutls28-dev \
    libtiff5-dev \
    libgif-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    libncurses-dev \
    libx11-dev \
    libxft-dev \
    libxext-dev \
    libxt-dev \
    libxfixes-dev \
    libxrender-dev \
    libice-dev \
    libsm-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxkbfile-dev \
    libxcb1-dev \
    libxcb-xfixes0-dev \
    libselinux1-dev \
    libjansson-dev \
    libxml2-dev \
    libsqlite3-dev \
    libacl1-dev \
    liblzma-dev \
    zlib1g-dev \
    libharfbuzz-dev \
    libfreetype6-dev \
    libsystemd-dev \
    libdbus-1-dev \
    libglib2.0-dev \
    libtree-sitter-dev \
    libgccjit-10-dev gcc-10 texinfo git chezscheme &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install tidyverse and essentials from CRAN
RUN Rscript -e "install.packages(c('tidyverse', 'data.table', 'devtools'), repos='https://cloud.r-project.org')"

# Build and install Emacs 30
RUN wget https://ftp.gnu.org/gnu/emacs/emacs-30.1.tar.xz && \
    tar -xf emacs-30.1.tar.xz && \
    cd emacs-30.1 && \
    ./configure --with-x-toolkit=gtk3 --with-modules --with-x  && \
    make bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf emacs-30.1 emacs-30.1.tar.xz

# Copy the rung dispatcher into /usr/bin and make it executable
COPY rung /usr/bin/rung
RUN chmod 755 /usr/bin/rung

# Create user
RUN useradd -ms /bin/bash rstudio && \
    echo "rstudio ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rstudio && \
    chmod 0440 /etc/sudoers.d/rstudio

# Install Python packages
RUN pip3 install  --no-cache-dir \
    websockets pexpect psutil aiohttp openai plotnine nltk siuba aiohttp beautifulsoup4 lxml diffusers torch transformers accelerate aiorp protobuf

# Install Podman client only
RUN apt-get update \
  && apt-get install -y podman \
  && rm -rf /var/lib/apt/lists/*

# Point Podman CLI at the host’s rootless socket
ENV PODMAN_HOST=unix:///run/user/1000/podman/podman.sock

# Install Java (OpenJDK 17) and Maven
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY bashrc /root/.bashrc
COPY Rprofile.site /etc/R/Rprofile.site

RUN pip install git+https://github.com/huggingface/diffusers
RUN pip install torchao sentencepiece

# Final setup
USER rstudio

WORKDIR /home/rstudio
CMD ["/bin/bash"]

```

To really understand what a Dockerfile says, we need to know a little Unix. We'll get there.
But Docker is also really handy because you can use it to just start a Unix shell to experiment
with for the early parts of this course and you can be sure you won't screw 
up your host system.
