# Day 03: Process & Service Management

## What I did today
Learned how to view and manage running processes, how to kill stuck processes, and how to manage services using systemctl. Also covered disk and memory checks — including the real-world scenario of figuring out what's eating up disk space.

## Concepts and Commands Learned

### Process Viewing
```bash
ps                    # processes in the current terminal
ps aux                 # ALL system processes (detailed — user, CPU, memory)
ps aux | grep name     # find a specific process (e.g. nginx, bash)
top                    # live dashboard (CPU/memory in real-time), press q to exit
```

**`ps aux` output columns:**
| Column | Meaning |
|--------|---------|
| USER | who started the process |
| PID | Process ID (unique number) |
| %CPU | CPU usage |
| %MEM | memory usage |
| COMMAND | which program is running |

**`top` status column:**
- `S` = sleeping (idle)
- `R` = running (active)
- `Z` = zombie (finished but not yet cleaned up)

### Killing Processes
```bash
kill PID       # gracefully stop a process
kill -9 PID    # force-kill a process (if it's stuck)
```
Example: `kill -9 4521`

### Service Management (the most important part)
```bash
sudo systemctl status servicename    # check status
sudo systemctl start servicename     # start the service
sudo systemctl stop servicename      # stop the service
sudo systemctl restart servicename   # stop and start again (after a config change)
sudo systemctl enable servicename    # automatically start on boot
```

**start vs enable:**
- `start` = run it right now
- `enable` = run it automatically every time the system boots

**After changing a config file:**
```bash
sudo systemctl restart servicename   # needed to load the new config
```

### Disk & Memory Checks
```bash
df -h              # disk space for the WHOLE drive (human-readable)
du -sh foldername  # size of a SPECIFIC folder
free -m            # RAM/memory usage (in MB)
```

**df vs du (important difference):**
- `df` = Disk Free → status of the entire drive/partition
- `du` = Disk Usage → status of a specific folder/file

**Real scenario — disk full:**
1. `df -h` → confirm which partition is full
2. `du -sh /var/log` → find out which folder is the culprit
3. Clean up that folder

## Where I got stuck
Understanding zombie processes (`Z` status) was confusing at first — took a moment to realize it means the process has finished but its exit status hasn't been read by the parent yet, not that it's still "running." Also had to be careful with `kill -9` since it's a force kill and can leave things in a bad state if used carelessly.

## Files in this folder
- `healthcheck.sh` — script to check service status/health

## Interview Question Prep

**Q: How do you check if a service is running?**
A: `sudo systemctl status servicename`

**Q: How do you restart a service after a config change?**
A: `sudo systemctl restart servicename`

**Q: Difference between `systemctl start` and `systemctl enable`?**
A: `start` runs the service immediately. `enable` makes it start automatically on every boot.

**Q: How do you kill a stuck/frozen process?**
A: First find the PID with `ps aux | grep processname`, then force-kill it with `kill -9 PID`.

**Q: Difference between `df` and `du`?**
A: `df` shows space for the whole drive. `du` shows the size of a specific folder.

**Q: How do you check disk usage of a folder?**
A: `du -sh foldername`
