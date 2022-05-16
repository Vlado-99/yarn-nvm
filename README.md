# yarn-nvm
Set correct node version according to package.json automatically when starting yarn.
Works with VSCode node-terminal launch configuration too.

### Limitations
  - Tested on Kubuntu only.
  - Needs dpkg and apt to check if installed and install needed packages.
  - `bash` is expected as a shell.

### Dependencies
  - `curl` package is needed for downloading during install.
  - `jq` package is needed for extracting version from `package.json` file.

### Install
```
curl https://raw.githubusercontent.com/Vlado-99/yarn-nvm/main/install.sh | bash
```

