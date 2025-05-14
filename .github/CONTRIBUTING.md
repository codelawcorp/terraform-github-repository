

### Configuring 🐙
When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.


- There are TODO comments in the code.
- There are GitHub issues
- Install git hooks. Run this command `git config core.hooksPath .githooks`.
- [Configure GPG keys if required](docs/GPG-KEYS.md)

Setup GitHub authentication

```bash
brew install gh
gh auth login
gh auth setup-git
git clone <this repo>
```

Configure Terraform
```bash
brew unlink terraform # if you have it installed
brew install tfenv
tfenv install <version>
tfenv use  <version>
```

### Deploying 🏋🏼

### Branching strategy 🚨
Default branch is `prod`.

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

