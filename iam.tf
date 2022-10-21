resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "ec2-s3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "Ec2Profile" {                            
     name  = "Ec2Profile"                         
    role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_iam_policy" "Policy" {
  name        = "Ec2_S3Policy"
  description = "Access to s3 policy from ec2"
  policy      = <<EOF
{
 "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": "s3:*",
           "Resource": "*"
       }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "Ec2-Attach" {
  role     = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.Policy.arn
}