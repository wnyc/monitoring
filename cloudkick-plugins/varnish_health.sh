#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

health=$(varnishadm -T localhost:6082 debug.health | egrep "^Backend ")
sick=$(echo $health | grep Sick)
if [[ "$sick" == *Sick* ]]; then
    echo "status err $sick"
fi
echo $health | sed 's/Healthy/1/' | sed 's/Sick/0/' | awk '{ print "metric " $2 "_healthy int " $4 }'
