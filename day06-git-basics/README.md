# Day 06: Git Deep Dive

## What I did today
Went deeper into Git — understood the 3-stage workflow properly, practiced branching and merging, and worked through an actual merge conflict end to end instead of just reading about it. Also learned about .gitignore and chaining commands with `;` vs `&&`.

## Concepts and Commands Learned

### Git 3-Stage Flow
```
Working Directory -> Staging -> Local Repo -> GitHub
     (edit)         (git add)   (git commit)  (git push)
```
```bash
git status         # check which stage a file is in
git log            # view full commit history
git log --oneline  # short summary format
```

### Status Meanings
| Status | Meaning |
|--------|---------|
| Untracked | Git isn't tracking this file yet (before `git add`) |
| Changes to be committed | File is staged (after `add`, before `commit`) |
| nothing to commit | Everything is clean, nothing pending |

### Branching
```bash
git branch              # list all branches (* marks current branch)
git branch name          # create a new branch
git checkout name        # switch to that branch
git checkout -b name     # create and switch in one step
git merge branchname     # merge another branch into the current one
```
**Concept:** a branch is a parallel, isolated copy of the code. Merging brings those changes back into the main branch.

### Merge Conflicts (the most important part)
**When it happens:** two branches change the **same line** in different ways.
**When it doesn't:** if different files or different lines were changed, Git merges automatically.

**Conflict markers (appear inside the file):**
<<<<<<< HEAD
(current/main branch's content)

(other branch's content)

branchname


**Steps to resolve:**
1. `git merge branchname` → conflict shows up
2. `nano filename` → open the file
3. Look at both versions, decide what the final content should be
4. Delete all the `<<<<<<<`, `=======`, `>>>>>>>` markers
5. Save (Ctrl+O, Enter, Ctrl+X)
6. `git add filename`
7. `git commit -m "Resolve merge conflict"`

### .gitignore
Create a `.gitignore` file and add patterns like:

*.log
temp/
secrets.txt

Git will stop tracking files matching these patterns — useful for keeping sensitive or junk files from accidentally being pushed to GitHub.

### Chaining Multiple Commands
```bash
command1; command2      # both run, even if the first one fails
command1 && command2    # second only runs if the first one succeeds
```

## Where I got stuck
Actually resolving a merge conflict for the first time was confusing — wasn't sure at first whether to keep both versions or pick one. Once I understood that the markers just show both options and I have full control over the final content, it made a lot more sense.

## Files in this folder
- *gittest.txt, file2.txt — git add/status/commit practice
feature.txt — branching practice (feature-test branch se merge hui)
conflict-test.txt — merge conflict practice (resolve karke final content bacha)
.gitignore — log files ignore karne ke liye
test.log — .gitignore test karne ke liye (ye track nahi hui, isliye ye push nahi hogi — normal hai)*

## Interview Question Prep

**Q: What is a merge conflict and when does it happen?**
A: It happens when two branches change the same line differently, and Git can't automatically decide which version to keep — so it raises a conflict for manual resolution.

**Q: How do you resolve a merge conflict?**
A: Open the file, look at the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`), compare both versions, decide on the final content, remove the markers, then `git add` and `git commit`.

**Q: What is the difference between `git add` and `git commit`?**
A: `git add` moves changes into the staging area, preparing them for commit. `git commit` permanently saves those staged changes into the local repository.

**Q: What is .gitignore used for?**
A: To prevent Git from tracking certain files — like logs, secrets, or temporary files.

**Q: Difference between `git branch name` and `git checkout -b name`?**
A: `git branch name` only creates a new branch. `git checkout -b name` creates the branch and switches to it immediately.
