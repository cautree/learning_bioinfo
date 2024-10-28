## install and configure aws to use ec2 instance

1) run these two lines of code to install aws on mac
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

2) use this to check if it is installed
```
which aws
```
3) configure aws
```
aws configure
#region: us-east-1
#format: json
```

4) put pem file under ~/.ssh folder
```
mkdir ~/.ssh
cp somebody.pem ~/.ssh
chmod 400 ~/.ssh/somebody.pem
```


## download only data ends with txt
```
aws s3 cp s3://seqwell-projects/Azenta_20241023/fulcrum/  . --exclude="*"  --include="*/*.txt" --recursive

```