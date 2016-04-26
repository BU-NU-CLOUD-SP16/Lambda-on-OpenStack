#!/bin/sh
ps -ef | grep queueReceiver.py | grep -v grep | awk '{print $2}' | xargs kill
