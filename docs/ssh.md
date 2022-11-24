# SSH

## Proxies

In order to connect to a server via a proxy, you can add the following to your
ssh config file.

```sshconfig
Host proxy
  HostName proxy.com
  User username
  IdentityFile ~/.ssh/id_rsa_proxy

Host server
  HostName server.com
  User username
  IdentityFile ~/.ssh/id_rsa_server
  ProxyJump proxy
```

Copying the keys to the server can then be done with

```bash
ssh-copy-id -i ~/.ssh/id_rsa -o ProxyJump <proxy> <user>@<host>
```

## Git Repositories via SSH

If you're cloning git repositories via SSH, you can add the following to you
ssh config file, so that SSH will automatically pick the correct public key.

```sshconfig
Host github.com
  HostName github.com
  User git
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_github
```

