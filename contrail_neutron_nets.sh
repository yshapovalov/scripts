#!/bin/bash

. keystonercv3

python /usr/share/contrail-utils/provision_mx.py --router_name vsrx1 \
                                                 --router_ip 172.16.10.250 \
                                                 --router_asn 64512 \
                                                 --api_server_ip 172.16.10.254 \
                                                 --api_server_port 8082 \
                                                 --oper add \
                                                 --admin_user admin \
                                                 --admin_password workshop \
                                                 --admin_tenant_name admin

#create internal network
neutron net-create admin_internal
neutron subnet-create --name internal_subnet \
                      --gateway 172.16.20.1 \
                      --enable-dhcp \
                      admin_internal "172.16.20.0/24"

#create floating network
neutron net-create admin_floating \
                      --router:external True
neutron subnet-create --name floating_subnet \
                      --gateway 192.168.20.1 \
                      --allocation-pool start=192.168.20.2,end=192.168.20.254 \
                      --enable-dhcp \
                      admin_floating "192.168.20.0/24"

python /usr/share/contrail-utils/add_route_target.py --routing_instance_name default-domain:$OS_TENANT_NAME:admin_floating:floating_subnet \
                                                     --route_target_number 10000 \
                                                     --router_asn 64512 \
                                                     --admin_user $OS_USERNAME \
                                                     --admin_password $OS_PASSWORD \
                                                     --admin_tenant_name $OS_TENANT_NAME \
                                                     --api_server_ip 172.16.10.254 \
                                                     --api_server_port 8082

#create router
neutron router-create Router04
neutron router-gateway-set Router04 admin_floating
neutron router-interface-add Router04 internal_subnet
