### Faking a Cisco router on CentOS with a fake Shell

- Run the script: `sh create_fake_device.sh`
- SSH to the fake device: `ssh -p 2222 cisco@127.0.0.1`
- If you're experiencing issues with SSH, you can run SSHD in foreground with debug key:

```
/sbin/sshd -dDe -f /root/fake_device_on_host/sshd_config_fake_device
```