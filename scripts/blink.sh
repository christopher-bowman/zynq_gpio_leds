#!/bin/sh
set -e

gpioctl -f /dev/gpioc0 -c EMIO_0 OUT
gpioctl -f /dev/gpioc0 -c EMIO_1 OUT
gpioctl -f /dev/gpioc0 -c EMIO_2 OUT
gpioctl -f /dev/gpioc0 -c EMIO_3 OUT

gpioctl -f /dev/gpioc0 -N EMIO_0 1
gpioctl -f /dev/gpioc0 -N EMIO_1 1
gpioctl -f /dev/gpioc0 -N EMIO_2 1
gpioctl -f /dev/gpioc0 -N EMIO_3 1

sleep 2

gpioctl -f /dev/gpioc0 -N EMIO_0 0
gpioctl -f /dev/gpioc0 -N EMIO_1 0
gpioctl -f /dev/gpioc0 -N EMIO_2 0
gpioctl -f /dev/gpioc0 -N EMIO_3 0

sleep 2

gpioctl -f /dev/gpioc0 -t EMIO_0
gpioctl -f /dev/gpioc0 -t EMIO_1
gpioctl -f /dev/gpioc0 -t EMIO_2
gpioctl -f /dev/gpioc0 -t EMIO_3

delay=$1
while : 
do
	for led0 in 0 1
	do
		gpioctl -f /dev/gpioc0 -N EMIO_0 $led0
		for led1 in 0 1
		do
			gpioctl -f /dev/gpioc0 -N EMIO_1 $led1
			for led2 in 0 1
			do
				gpioctl -f /dev/gpioc0 -N EMIO_2 $led2
				for led3 in 0 1
				do
					gpioctl -f /dev/gpioc0 -N EMIO_3 $led3
					#echo $led0 $led1 $led2 $led3
					sleep $delay 
				done
			done
		done
	done
done 