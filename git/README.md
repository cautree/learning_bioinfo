https://kbroman.org/github_tutorial/pages/first_time.html

```
git config --global user.name "cautree"
git config --global user.name "YanyanL"
git config --global user.email "aaa@gmail.com"
git config --global color.ui true
git config --global core.editor "nano"

ssh-keygen -t ed25519 -C "aaas@gmail.com"

```


Your identification has been saved in /Users/yanyan/.ssh/id_ed25519
Your public key has been saved in /Users/yanyan/.ssh/id_ed25519.pub

pbcopy < ~/.ssh/id_ed25519.pub
add the ssh key to gitlab or github

## After you've set up your SSH key and added it to GitHub, you can test your connection.
```
ssh -T git@github.com
sh-add -l -E sha256

# trouble shoot
# https://github.com/orgs/community/discussions/33982
# https://gist.github.com/bsara/5c4d90db3016814a3d2fe38d314f9c23

```

## need to use authentication token, not passwd
https://stackoverflow.com/questions/68775869/message-support-for-password-authentication-was-removed


## clone a repo and contribute to it from aother branch
```
https://medium.com/@akshaysen/clone-a-repository-create-a-branch-and-pull-new-changes-1bd732a812fb

git clone git@gitlab.com:seqwell/nextflow-demux.git

cd nextflow-demux


git branch 'dev-2025'
git checkout 'dev-2025'
git status
git add .
git commit -m 'from dev-2025'

git push --set-upstream origin 'dev-2025'

```


## git hub having a new release
```
https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository

```


## undiverge
master branch and 'origin/master' have diverged, how to 'undiverge' branches'?
https://stackoverflow.com/questions/2452226/master-branch-and-origin-master-have-diverged-how-to-undiverge-branches

```
git add .
git commit -m "a commit before merge"
git merge origin/main
git push


```

## get back to specific commit
```
git reset --hard 4a155e5
```

