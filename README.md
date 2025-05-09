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

## Help vm-cli output

```text
Version: $VM_CLI_VERSION

Usage: vm-cli [GLOBAL COMMAND] [OPTIONS]
       vm-cli [--vm NAME|UUID] [VIRTUAL MACHINNE COMMAND] [OPTIONS]

OPTIONS:
  --vm                Specify the Virtual Machine Name or UUID.
                      Required unless VM_CLI_VM_DEFAULT is set in environment.
                      You can also use --name, --uuid, or --id.

GLOBAL COMMANDS:
  list                List all Virtual Machines.
    --running         Show only running.
  help                Show this help message.
  version             Show version information.
  update              Updates wm-cli to the latest version.
    --token           Specify the GitHub token for authentication.
                      Required if you have exceeded the GitHub API rate limit.

VIRTUAL MACHINE COMMANDS:
  See the VBoxManage documentation for more details.
  https://www.virtualbox.org/manual/ch08.html

  start               Start the Virtual Machine.
    --type            Set the type of the Virtual Machine (headless by default).
    --putenv, -E      Set environment variables for the Virtual Machine.
    --password        Set the password file for the Virtual Machine.
    --password-id     Set the password ID for the Virtual Machine.
  stop                Stop the Virtual Machine (saves state by default).
    --save            Save the Virtual Machine state.
    --acpi            Send ACPI power button signal.
    --sleep           Send ACPI sleep signal.
                      Only work if the guest OS supports it.
    --poweroff        Power off the Virtual Machine immediately.
  save                Alias for 'stop --save'.
  poweroff            Alias for 'stop --poweroff'.
  shutdown            Asks the guest OS to shutdown.
    --force           Force shutdown.
  reboot              Reboot the virtual machine.
  pause               Pause the Virtual Machine.
  resume              Resume the Virtual Machine.
  control             Pass the defined subcommand directly to VBoxManage controlvm.
  ssh                 SSH into the Virtual Machine. Requires Host-Only.
                      This command will autostart the Virtual Machine.
                      Use -- to pass arguments to ssh to separate the args.
  status              Show Virtual Machine running status.
  ip                  Show the Host-Only IP address of the Virtual Machine.
                      This command will autostart the Virtual Machine.

ENVIRONMENT:
  VM_CLI_VM_DEFAULT   Default Virtual Machine.
  VM_CLI_CMD_TIMEOUT  Max. time the command will attempt to execute, in seconds.
                      Default: 30 seconds.
```
