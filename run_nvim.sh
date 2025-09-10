#!/bin/bash

HOME_DIR=Codebase
DOCKER_HOME=/home/nicola/Codebase

print_use() {
  echo "run_vim: <file_or_dir>"
}

if [[ -z ${1} ]]; then
  echo "Error: missing argument"
  exit 1
fi

if [[ ! -e ${1} ]]; then
  echo "Error: '${1}' is not a file or a directory"
  exit 1
fi

# We get the fullpath because when we
# filter out the path later we can use the
# root / symbol to check if the filter has
# been applied or not
regex="s#.*/${HOME_DIR}/##g"
fullpath=$(realpath ${1})
INPUT=$(echo ${fullpath} | sed -e "${regex}")

if [[ "${INPUT:0:1}" = "/" ]]; then
  echo "Running nvim normally..."
  nvim $1
  exit 0
fi

DIR=${INPUT}

if [[ -d ${fullpath} ]]; then
  INPUT="."
else
  DIR=$(dirname ${DIR})
  regex="s#.*${DIR}/##g"
  INPUT=$(echo ${INPUT} | sed -e "${regex}")
fi

docker exec -it nvim bash -c "cd ${DOCKER_HOME}/${DIR}; nvim ${INPUT}"

