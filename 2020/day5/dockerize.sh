IMAGE=python:3.6


docker run -it --rm \
  -v ${PWD}:/src \
  -w /src \
  $IMAGE \
  $@
