#!/usr/bin/env bash

# Terminate polybar running instances
killall -q polybar

polybar debian 2>&1 | tee -a /tmp/polybat_logo.log &
polybar left 2>&1 | tee -a /tmp/polybar_left.log &
polybar center 2>&1 | tee -a /tmp/polybar_center.log &
polybar right 2>&1 | tee -a /tmp/polybar_right.log &
