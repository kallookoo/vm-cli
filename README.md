# vm-cli

>[!NOTE]
> Currently under development.

Command to simplify the use of VirtualBox (VBoxManage) from the terminal.

>[!IMPORTANT]
> Do not copy&paste the code unless you know what you are doing.

## Download & Install

```shell
(
    curl -sfL "https://github.com/kallookoo/vm-cli/releases/download/v1.0.0/vm-cli.tar.gz" | \
    tar -xzf - -C "$HOME/.local/bin" && chmod u+x "$HOME/.local/bin/vm-cli"
)
```

## Update

Normal mode:

```shell
vm-cli update
```

Using the token and obtain with the gh command.

```shell
wm-cli update --token "$(gh auth token)"
```
