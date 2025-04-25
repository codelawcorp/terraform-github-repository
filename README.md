# README
This is a repo template 👨🏼‍🔬

## Description 🤝

Short.
What was your motivation?  
What problem does it solve?  
What application does?
Why you used the technologies you used?

* ⚠️ Do not change repo settings manually in UI. It is managged by Terraform, including variables, secrets, environmetns, protected branches etc.  
## Getting started 🚀

##  Development 🐙
Setup GitHub authentication

```bash
brew install gh
gh auth login
gh auth setup-git
git clone <this repo>
```

### Configuring

- There are TODO comments in the code.
- Install git hooks. Run this command `git config core.hooksPath .githooks`.
- [Configure GPG keys if required](doc/GPG-KEYS.md)

### Building 🧱

### Deploying 🏋🏼

### Branching strategy 🚨

- Branches are named after environments.
- Number of environments `==` number of branches. E.g. for `prod`, `stg`, `dev` environments, you should have `prod`, `stg`, `dev` branches respectively.
- The default branch should be `prod`, not `master`/`main`.
- Do development on `dev` branch. Propagate changes from `dev` -> `stg` -> `prod` branches. CI/CD will deploy to respective environments upon merging. Merging is a deployment trigger.
  Also recommended:
- Do not protect `dev` branch. Do [Trunk Based Development](https://www.youtube.com/watch?v=v4Ijkq6Myfc) on a `dev` branch e.g. everyone can push there. Developers collaborate by doing pull-rebase/push often. Automated tests is a must.
- Configure on-demand mini-dev per-developer so developers can experiment there, but dev should be accessible to push to integrate changes frequently.
- If a startup with no users, do everything in `prod` and `prod` branch.

With this branching strategy you are always certain which version of code is deployed to your envs.
Merging is deploying.

#### Semantic Versioning

Code is versioned according to this convention [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/#summary).  
When a new commit is pushed to the default branch (`prod`), GHA runs an npm script which determines the next version and pushes a git tag. Optionally, it generates `CHANGELOG.md`.

- To force-trigger a new version without actually making any changes, run `git commit --allow-empty -m "fix: trigger release with empty commit" && git push`

## Useful links

- [Choose License](https://choosealicense.com/)
- Use [this tool](https://githubnext.com/projects/repo-visualization/) to explore the project if it is large
- [.gitignore file generator](https://www.toptal.com/developers/gitignore/)
- [Markdown table generator](https://www.tablesgenerator.com/markdown_tables)
- [Kubernetes Manifests Generator](https://k8syaml.com/)
- [Generate banner online](https://manytools.org/hacker-tools/ascii-banner/)
- [Jam - UI bug reports](https://jam.dev/)
  Enjoy Coding ❤
