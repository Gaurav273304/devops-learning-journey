# Day 01-02: Linux Basics + Permissions & Users

## What I did
Started with basic Linux navigation and file operations, then moved into permissions, ownership, and writing my first bash script. Also practiced live log monitoring, which is something used a lot in production environments.

---

## Day 1: Linux Basics

### Navigation
```bash
pwd          # shows current location
ls           # lists files/folders
ls -la       # shows hidden files too (detailed view)
cd folder    # go into a folder
cd ..        # go up one level
cd ~         # go back to home directory
cd /         # go to root directory (top of the filesystem)
```

### File/Folder Operations
```bash
mkdir name       # create a new folder
touch file.txt   # create a new empty file
cp source dest   # COPY (original file stays)
mv source dest   # MOVE/RENAME (original file is gone)
rm file.txt      # delete a file
```

### Viewing Files
```bash
cat file.txt          # show the entire file
echo "text" > file    # write to a file (overwrites existing content)
echo "text" >> file   # append to a file (keeps existing content)
head file.txt         # show the first lines (default 10)
tail file.txt         # show the last lines (default 10)
head -n 2 file.txt    # only the first 2 lines
tail -n 2 file.txt    # only the last 2 lines
```

### Live Monitoring (important — used a lot in production)
```bash
tail -f file.txt   # watches a file live, shows new data as it's written
                     # Ctrl+C to stop
```

### Searching
```bash
find . -name "*.txt"   # find all .txt files in the current folder
```

### Key Concepts to Remember
- `cp` = COPY (file exists in both places)
- `mv` = MOVE (file exists only in the new location, original is gone)
- `>` = OVERWRITE (old content is erased)
- `>>` = APPEND (old content + new content)

---

## Day 2: Permissions & Users

### Permission Structure

-rwxr-xr--
| | | |
| | | type
| | others
| group
owner

- `r` = read (4)
- `w` = write (2)
- `x` = execute (1)
- `-` = no permission (0)

### chmod — Letter Method
```bash
chmod u+x file   # give owner execute permission
chmod g+x file   # give group execute permission
chmod o-w file   # remove write permission from others
chmod a+x file   # give everyone execute permission
```
- `u` = user/owner
- `g` = group
- `o` = others
- `a` = all

### chmod — Numeric Method
```bash
chmod 755 file   # rwxr-xr-x (owner: full, group/others: read+execute)
chmod 644 file   # rw-r--r-- (owner: read+write, group/others: read)
chmod 700 file   # rwx------ (only owner has any access)
chmod 777 file   # rwxrwxrwx (everyone has full access — risky, avoid)
```

**Calculation:**
| Permission | Value |
|------------|-------|
| rwx | 4+2+1 = 7 |
| rw- | 4+2+0 = 6 |
| r-x | 4+0+1 = 5 |
| r-- | 4+0+0 = 4 |

### Ownership
```bash
whoami                 # check current user
ls -l file              # check a file's owner/group
sudo chown user file    # change a file's owner (requires sudo)
sudo useradd name       # create a new user
sudo userdel name       # delete a user
```

### sudo
Runs a command with superuser permissions. Required for system-level changes like modifying users or ownership.

### Text Editor — nano
```bash
nano filename   # opens/creates a file in the editor
```
- `Ctrl+O` → save
- `Ctrl+X` → exit

### First Bash Script
```bash
#!/bin/bash        # shebang line — tells the system to run this with bash
echo "message"      # prints text to the terminal
df -h                # checks disk space (human-readable)
chmod +x script.sh   # makes the script executable
./script.sh           # runs the script
```

## Where I got stuck
Understanding the numeric permission system (755, 644, etc.) took a bit of practice — kept having to manually add up read/write/execute values until it became second nature. Also mixed up `>` and `>>` once and accidentally overwrote a file's content.

## Files in this folder
- `file1.txt`, `test.txt` — used for basic file operation practice
- `myscript.sh`, `myscript1.sh`, `myscript2.sh`, `myscript3.sh` — early bash script practice
- `diskcheck.sh` — script using `df -h` to check disk space

## Interview Question Prep

**Q: How do you check the last 50 lines of a log file?**
A: `tail -n 50 filename.log`

**Q: How do you monitor a live log file?**
A: `tail -f filename.log`

**Q: Difference between `cp` and `mv`?**
A: `cp` copies a file (it exists in both locations). `mv` moves a file (it exists only in the new location).

**Q: How do you give execute permission to a script?**
A: `chmod +x scriptname.sh` or `chmod 755 scriptname.sh`

**Q: What does `chmod 755` mean?**
A: Owner gets read+write+execute; group and others get read+execute.

**Q: Difference between `chmod` and `chown`?**
A: `chmod` changes permissions (what actions are allowed). `chown` changes ownership (who owns the file).

**Q: What is a shebang line?**
A: `#!/bin/bash` — it tells the system which interpreter/shell to use when running the script.
