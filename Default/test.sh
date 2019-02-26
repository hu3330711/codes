#!/bin/sh

#PBS -N testrun
#PBS -l walltime=00:01:00
#PBS -M sdusxc@gmail.com
#PBS -m abe

module load idl/8.6.0

cd ~/idlCode/

idl HelloWorld
