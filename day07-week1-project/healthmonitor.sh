#!/bin/bash

disk_threshold=80
logfile="monitor.log"

echo "====================================" >> $logfile
echo "Health check: $(date)" >> $logfile

disk_usage=$(df -h / | grep / | awk '{print $5}' | sed 's/%//')
echo "Disk Usage: $disk_usage%" >> $logfile

if [ $disk_usage -gt $disk_threshold ]
then
    echo "WARNING: Disk usage is above ${disk_threshold}%" >> $logfile
else
    echo "Disk usage is normal" >> $logfile
fi

free_memory=$(free -m | grep Mem | awk '{print $4}')
echo "Free Memory: ${free_memory}MB" >> $logfile

if ps aux | grep -v grep | grep "bash" > /dev/null
then
    echo "bash process is running" >> $logfile
else
    echo "WARNING: bash process not found" >> $logfile
fi

echo "Health check complete" >> $logfile

