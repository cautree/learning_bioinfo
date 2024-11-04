https://lpembleton.rbind.io/posts/nextflow-on-aws-batch/
1) create a new user 
2) user name "Nextflow-access", give admin access
3) create instance in AWS Marketplace AMIs: amzn2-ami-ecs-hvm-2.0.20241023-x86_64-ebs, the login credential should be the the same as the user
4) launch instance, and install aws cli
```
cd $HOME
sudo yum install -y bzip2 wget
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/miniconda
$HOME/miniconda/bin/conda install -c conda-forge -y awscli
rm Miniconda3-latest-Linux-x86_64.sh

##verify it is successful

./miniconda/bin/aws --version
```
5.Under the Instances menu in the EC2 console select your relevant instance and click Actions, 
then Images and Templates, then Create Imag.
Give your new image a name e.g. nextflow-30GiB-ecs-ami and click Create image
6)ake note of the AMI ID (not the name) that you just generated as you will need this later
ami-0f8cf0d083b1831ce