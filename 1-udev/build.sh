#!/bin/sh
CFLAGS=`pkg-config --cflags libudev`
LIBS=`pkg-config --libs libudev`
C=gcc

$C  udev_monitor.c $CFLAGS $LIBS -o udev_monitor

