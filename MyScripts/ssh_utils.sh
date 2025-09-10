#!/bin/bash

LAST_HOST_FILE=$HOME/MyScripts/.config/.ssh/last_host

function ssh_hosts() {
  LAST_SSH_HOST=$(cat $HOME/.ssh/config | ag "Host [^*]+" | cut -f2 -d " " | sort | fzf)
}

function ssh_connect_to_last() {
  if [[ -d $(dirname ${LAST_HOST_FILE}) ]]; then
    mkdir -p $(dirname ${LAST_HOST_FILE})
  fi

  if [[ -z ${LAST_SSH_HOST} || ! -f ${LAST_HOST_FILE} ]]; then
    ssh_hosts
  fi
  if [[ ! -z ${LAST_SSH_HOST} ]]; then
   echo ${LAST_SSH_HOST} > ${LAST_HOST_FILE}
   ssh ${LAST_SSH_HOST}
  fi

}
