#!/home/ec2-user/nextflow/nextflow


params.days = 83d

process bs_rm {
  
     container '512431263418.dkr.ecr.us-east-1.amazonaws.com/bcl2fq'
     """
     
     #bs list runs --older-than=${params.days} --terse | xargs -n1 bs delete run --id
     
     bs list projects --older-than=${params.days} --terse |  xargs -n1 bs delete project --id
     
     """
}

