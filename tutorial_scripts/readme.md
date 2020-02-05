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
```
# setup VPC, Security Group, Security rules, 2 subnets, 2 ElasticIP, 1 internet gateway, 1 NAT gateway, one t2.micro Ubuntu instance for the jumpbox
./aws-create-bosh-env.sh bosh
```

# Create a BOSH Director and load configs
```
# ssh into jumpbox
# ssh -i bosh.pem ubuntu@34.205.55.122
./go

# run 'create-env' (bosh create-env)
./do-bosh.sh create-env

# load BOSH context
source bosh-alias.sh

# show current env
bosh env

# set basic cloud config
./update-cloud-config.sh

# show deployments (should be empty)
bosh deployments

# show vms (should be empty)
bosh vms
```
# Test Deployment from EC2 jumpbox
### Deploying Apache Zookeeper
```
# upload stemcell required by ZooKeeper
bosh upload-stemcell --sha1 6b3127103e012bd5b1a6d84009f05817ec433bb2 \
  https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-xenial-go_agent?v=621.51
  
# get ZooKeeper manifest
wget xxxx
# deploy 3 cluster instance of Apache zookeeper
bosh -d zookeeper deploy -v zookeeper_instances=3 zookeeper.yml

# show avail deployments (zookeeper should exist now)
bosh deployments

# show instantiated VM (should be 3)
bosh -d zookeeper vms
```
### smoke tests
```
bosh -d zookeeper run-errand smoke-tests
```

### A deeper test
```
# use BOSH to ssh into the node
bosh -d zookeeper ssh zookeeper/0

# now inside first zookeeper node
# change directory and make JAVA_HOME available
cd /var/vcap/packages/zookeeper
export JAVA_HOME=/var/vcap/packages/openjdk-8/jre

# run CLI client
bin/zkCli.sh

# issue the following commands
ls /
create /zk_test my_data
ls /
get /zk_test
delete /zk_test
ls /
quit
```

### Delete
```
# delete ZooKeeper cluster
bosh -d zookeeper delete-deployment

# should not show ZooKeeper anymore
bosh deployments

# delete stemcell ZooKeeper required
bosh stemcells
bosh delete-stemcell bosh-warden-boshlite-ubuntu-trusty-go_agent/3586.60

# delete BOSH Director
./do-bosh delete-env
```

