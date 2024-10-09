
## policy to access  s3://seqwell/shared/univrit/

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowStatement1",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Sid": "AllowStatement2A",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::seqwell"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:prefix": [
                        "shared/univrit"
                    ],
                    "s3:delimiter": [
                        "/"
                    ]
                }
            }
        },
        {
            "Sid": "AllowStatement3",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::seqwell"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "shared/univrit/*"
                    ]
                }
            }
        },
        {
            "Sid": "AllowStatement4A",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::seqwell/shared/univrit/*"
            ]
        }
    ]
}


```