#!/bin/bash
PORTS=$(neutron port-list | grep snat | cut -d "|" -f 2)
for port_uuid in $PORTS
do 
    neutron port-delete $port_uuid
done

NETS=$(neutron net-list | grep snat | cut -d "|" -f 2)
for net_uuid in $NETS
do
    neutron net-delte $net_uuid
done
