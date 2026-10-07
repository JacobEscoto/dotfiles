#!/usr/bin/env bash

# Script for launching my custom polybar (3 blocks)

# Terminate polybar running instances
killall -q polybar

polybar left 2>&1 | tee -a /tmp/polybar_left.log &
polybar center 2>&1 | tee -a /tmp/polybar_center.log &
polybar right 2>&1 | tee -a /tmp/polybar_right.log &
