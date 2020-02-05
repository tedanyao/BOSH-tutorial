https://fabianlee.org/2019/01/12/cloudfoundry-installing-a-bosh-director-on-aws/

# BOSH setup
1. Install BOSH

# AWS setup
1. Create an IAM user with the policy in "./aws-iam-policy.json"
2. Install AWS CLI  
  a. https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html  
  b. install  
  ```
  $ curl "https://d1vvhvl2y92vvt.cloudfront.net/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  $ sudo installer -pkg AWSCLIV2.pkg -target /
  ```
  
  c. check status
  ```
  $ which aws2
  /usr/local/bin/aws2 
  $ aws2 --version
  aws-cli/2.0.0dev4 Python/3.7.4 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.0.0dev3
  ```
  d. setup an alias for compatibility: aws -> aws2
  ```
  ln -s /usr/local/bin/aws2 /usr/local/bin/aws
  ```

# Create a jumpbox
