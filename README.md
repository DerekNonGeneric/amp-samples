# amp-samples

Boilerplate for adding embedded samples in AMP docs. Based on [How to: Include embedded samples in AMP docs](https://github.com/ampproject/docs/blob/master/contributing/adding-embedded-samples-in-docs.md) by [Barb Paduch](https://github.com/bpaduch).

**WARNING:** A new method exists. Update coming soon!

## Features

- Auto-deploys built products to gh-pages with Travis
- Deploys from branch specified in config

## Instructions 

1. Fork this repo
1. Create a new branch for your component's samples
1. Sign up for Travis and add your repository
1. Run `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
1. For the first dialogue of this command enter: `./deploy_key`
1. For the second dialogue of this command press enter (leave blank)
1. Add the contents of `deploy_key.pub` to your repository at `https://github.com/<username>/<repo>/settings/keys`
1. Run `travis encrypt-file deploy_key`
1. Copy the encryption label (i.e for `$encrypted_0a6446eb3ae3_key`, it would be `0a6446eb3ae3`)
1. Manually define the `ENCRYPTION_LABEL` and `COMMIT_AUTHOR_EMAIL` variables in the Travis Repository Settings
1. Manually edit the `branchName` and `host` variables in the `/tasks/config.js` file
1. Add your samples to the `/samples/src/` directory
1. Commit and push
1. Allow the Travis build to complete
1. View live samples at https://username.github.io/amp-samples/samples/ampcomponent.basic-sample.preview.html
