#!/usr/bin/env bash

#set -x
set -e
set -o errexit

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${scriptDir} || exit 13


ssh -o ExitOnForwardFailure=yes -f -N -L 8888:localhost:8080 myzima1a
firefox http://localhost:8888/dashboard
proc=$( ps -auxww | grep -v grep | grep -i 'L 8888:localhost:8080' )
pid=$( echo "${proc}" | awk '{ print $2 }' )
if [ -z ${pid} ]
then
  echo "pid is empty [${pid}]"
else
  echo "killing  pid [${pid}] proc [${proc}]"
  kill -9 ${pid}
fi
proc=$( ps -auxww | grep -v grep | grep -i 'L 8888:localhost:8080' )
pid=$( echo "${proc}" | awk '{ print $2 }' )
if [ -z ${pid} ]
then
  echo "good pid is empty [${pid}]"
  exit 0
else
  echo "bad proc still running [${proc}]"
  exit 13
fi
