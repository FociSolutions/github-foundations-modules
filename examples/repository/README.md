
#### Overview
This Terraform module creates a private GitHub repository with configurable options such as branch protection rules, team permissions, topics, homepage URL, auto-merge settings, security updates, and more. It allows for detailed customization of repository settings, including action, codespace, and dependabot secrets, as well as defining environments and applying license templates.

#### Notes
- Customize the variable values to fit your specific requirements.
- For secrets (`action_secrets`, `codespace_secrets`, `dependabot_secrets`), ensure the values are encrypted using the GH CLI as explained [here](https://github.com/FociSolutions/github-foundations/blob/main/docs/gh-secrets.md).