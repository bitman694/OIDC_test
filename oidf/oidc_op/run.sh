#!/usr/bin/env bash

trap 'kill ${!}; term_handler' SIGHUP SIGINT SIGQUIT SIGTERM

term_handler() {
  echo "term_handler"
  service ntp stop
  killall python3
  exit 143; # 128 + 15 -- SIGTERM
}

service ntp start

#echo -n "Starting op_test_tool.py ... "
#python3 op_test_tool.py -s -i https://op:4433 -t default -p 60003 -f flows -k tt_config &
#if [ $? -eq 0 ] ; then
#  echo "OK"
#else 
#  echo "ERROR"
#  exit -1
#fi

export DEBIAN_FRONTEND=noninteractive
export SRCDIR=/usr/local/src
export INSTDIR=oidf
export SUBDIR=${SRCDIR}/${INSTDIR}/oidc_op
export WORKDIR=${SRCDIR}
export VERSION_OTEST=tags/v0.7.8


echo -n "Starting config_server.py ... "
python3 config_server.py -t -k -p 60100 -H html -c tt_config config &
if [ $? -eq 0 ] ; then
  echo "OK"
else 
  echo "ERROR"
  exit -1
fi

while true
do
  tail -f /dev/null & wait ${!}
done

echo "exited $0"
