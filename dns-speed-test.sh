#!/bin/bash

while true; do dig $1 | grep time; sleep 2; done
