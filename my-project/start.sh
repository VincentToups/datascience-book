docker build . -t my-project
docker run --rm \
  -e USERID="$(id -u)" -e GROUPID="$(id -g)" \
  -p 8787:8787 \
  -v $(pwd):/home/rstudio/work \
  my-project
