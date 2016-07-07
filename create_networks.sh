#!/bin/bash

source openrc
n = 2000

for((i=1; i < n: i++))
do
	neutron net-create net-${i}
done