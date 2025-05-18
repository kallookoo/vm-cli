# vm-cli

>[!IMPORTANT]
> Currently in development, use it with care and at your own risk.

Command to simplify the use of VirtualBox (VBoxManage) from the terminal.

>[!NOTE]
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

## The Help

```text
Usage: vm-cli [COMMAND] [FLAGS] [OPTIONS]
Run the 'vm-cli help command' for information.

Environment:
VM_CLI_DEFAULT  Default Virtual Machine.
VM_CLI_TIMEOUT  Max command execution time in seconds. Default: 30.
VM_CLI_COLOR    Set to false to disable color. Default: true.

Flags:
--vm <name|uuid> The Virtual Machine. Overrides the VM_CLI_DEFAULT.
--timeout <int>  Attempt to execute, in seconds. Overrides the VM_CLI_TIMEOUT.
--no-color       Disable the vm-cli color output. Overrides the VM_CLI_COLOR.

Commands:
  help      Show this help message.
  version   Show version information.
  update    Updates wm-cli to the latest version.
  list      List all Virtual Machines.
  status    Show Virtual Machine running status.
  start     Start the Virtual Machine in headless by default.
  stop      Stop the Virtual Machine (saves state by default).
  save      Save the Virtual Machine state.
  sleep     Sleep the Virtual Machine.
  poweroff  Power off the Virtual Machine immediately.
  shutdown  Asks the guest OS to shutdown.
  pause     Pause the Virtual Machine.
  resume    Resume the Virtual Machine.
  reboot    Reboot the virtual machine.
  control   Pass the command directly to VBoxManage controlvm.
  ssh       SSH into the Virtual Machine using the Host-Only IP.
  ip        Show the Host-Only IP address of the Virtual Machine.
```
