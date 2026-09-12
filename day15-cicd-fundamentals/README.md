# Day 15: CI/CD Fundamentals

## What I did
Learned why CI/CD exists, worked through the precise differences between CI, Continuous Delivery, and Continuous Deployment, and built my first two GitHub Actions workflows - one guided, one fully self-implemented.

## Concepts Learned

### Why CI/CD
Manually testing and deploying code becomes slow and error-prone once multiple developers are pushing changes frequently. CI/CD automates testing, building, and deployment - it doesn't make code error-free, but it catches errors early, before they reach production.

### CI vs Continuous Delivery vs Continuous Deployment
- CI (Continuous Integration) - developers frequently merge code into a shared repo; each merge is automatically tested, keeping conflicts small and manageable.
- Continuous Delivery - code is automatically tested and built, ready to deploy, but a human manually triggers the final production deployment.
- Continuous Deployment - the manual step is removed entirely; passing tests automatically go live in production.

Most companies use Continuous Delivery rather than full Continuous Deployment, as a safety check before anything reaches production.

### GitHub Actions Basics
GitHub's built-in CI/CD tool. Workflow files must live at:
.github/workflows/filename.yml

Basic structure:
name: Hello World Workflow

on: push

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Say Hello
        run: echo "Hello DevOps World!"

- on defines the trigger (e.g. push)
- jobs defines what work happens
- runs-on defines the machine/OS
- steps are the actual commands, run in sequence

## Where I got stuck
Pushing the first workflow file failed with a Personal Access Token permission error - GitHub requires the workflow scope specifically to create or update Actions files, separate from the standard repo scope used for normal pushes. Generated a new token with both scopes and the push went through.

## Self-practice exercise
Independently wrote a second workflow (practice1.yml) with two build steps, without step-by-step guidance:
name: practice1 workflow

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Say Hello
        run: echo "Starting build process"
      - name: Build Complete
        run: echo "Build complete"

Made one mistake on the first attempt - wrote a step with only a name and no run command, which does nothing on its own. Caught and fixed it before pushing. Verified via the Actions tab that both steps ran successfully and printed the expected output.

## Files in this folder
- notes.md - working notes from the session
- (workflow files live in .github/workflows/ at the repo root: hello-world.yml, practice1.yml)

## Interview Question Prep

Q: Why do companies need CI/CD?
A: Manual testing and deployment becomes slow and error-prone with frequent code changes from multiple developers. CI/CD automates the process, making it faster and more consistent, and catches errors earlier in the pipeline.

Q: What's the difference between Continuous Delivery and Continuous Deployment?
A: Both automatically test and build the code. Delivery stops short of production - a human manually approves the final deploy. Deployment removes that manual step entirely.

Q: Where does a GitHub Actions workflow file need to live?
A: At .github/workflows/filename.yml - GitHub only looks in this exact path.

Q: What GitHub token scope is required to push Actions workflow files?
A: The workflow scope, in addition to the standard repo scope.
