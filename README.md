# Contributing Guide

Thank you for your interest in contributing! Please follow the steps below to keep the project clean and organized.

---

## Prerequisites

- Git installed on your machine
- A GitHub account
- Access to the repository (fork it if you are not a collaborator a meskin)

---

## Workflow

### 1. Clone the repository

```bash
git clone git@github.com:Raougah/Fih-Portal.git
cd fih-portal
```

### 2. Make sure your main branch is up to date

Before creating a new branch, always sync with the latest changes:

```bash
git checkout main
git pull origin main
```

### 3. Create a new branch

Never work directly on `main`. Create a dedicated branch for your changes:

```bash
git checkout -b your-feature-name
```

Use a clear, descriptive branch name. Examples:

- `add-khra`
- `fix-blabla`
- `update-zaft`

### 4. Make your changes

Edit files, add new content, fix bugs, etc.

### 5. Stage and commit your changes

```bash
git add .
git commit -m "Short description of what you changed or just blala"
```

### 6. Push your branch to GitHub

```bash
git push origin your-feature-alkhanza
```

### 7. Open a Pull Request (PR)

1. Go to the repository on GitHub
2. Click **"Compare & pull request"** (GitHub will suggest it automatically)
3. Write a clear title and description of your changes
4. Submit the PR and wait for the owner (dak smin) to review it

---

## After Your PR is Merged

Once the owner merges your PR, clean up your branches:

```bash
# Switch back to main
git checkout main

# Pull the latest merged changes
git pull origin main

# Delete your local branch
git branch -d your-feature-alkhanza

# Delete your remote branch (if not already deleted on GitHub)
git push origin --delete your-feature-alkhanza
```

> GitHub also offers a "Delete branch" button right after merging. If it was clicked, skip the last command.

---

## Rules

- Always branch off from `main`
- One feature or fix per branch
- Never push directly to `main`
- Keep commit messages short and meaningful
- Make sure your branch is up to date with `main` before opening a PR to avoid conflicts

---

## Editor Tip

After any pull dirah your terminal open vim editor just write any thing after pressing `i` or leave him alone then press `escape + :wq` :  

---

## Need Help al bou9al ?

Open an issue on GitHub and describe your problem clearly.
