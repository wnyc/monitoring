#!/bin/bash

# TODO merge this into cloudkick's varnish plugin and send them a pull request.

set -o errexit
set -o nounset
set -o pipefail

health=$(varnishadm -T localhost:6082 debug.health | egrep "^Backend ")
sick=$(echo $health | grep Sick) || true
if [[ "$sick" == *Sick* ]]; then
    echo "status err $sick"
else
    echo "status ok ok"
fi
echo "$health" | sed 's/Healthy/1/g;s/Sick/0/g' | awk '{ print "metric " $2 "_healthy int " $4 }'
