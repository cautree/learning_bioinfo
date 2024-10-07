https://kbroman.org/github_tutorial/pages/first_time.html

```
git config --global user.name "cautree"
git config --global user.email "aaa@gmail.com"
git config --global color.ui true

ssh-keygen -t ed25519 -C "aaas@gmail.com"
```


Your identification has been saved in /Users/yanyan/.ssh/id_ed25519
Your public key has been saved in /Users/yanyan/.ssh/id_ed25519.pub

pbcopy < ~/.ssh/id_ed25519.pub

## need to use authentication token, not passwd
https://stackoverflow.com/questions/68775869/message-support-for-password-authentication-was-removed
