# Start from rocker/verse (includes R, tidyverse, knitr, etc.)
FROM rocker/verse:latest

# Ensure root
USER root

# Install TeX Live, Pandoc, and extra LaTeX packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-xetex \
    texlive-luatex \
    lmodern \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install/upgrade R packages for rendering
RUN Rscript -e "install.packages(c('rmarkdown'), repos='https://cloud.r-project.org')"

# Default workdir
WORKDIR /project

