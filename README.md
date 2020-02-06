# BOSH-tutorial
This tutorial is about setting up a cloud foundry environment and deploying an application on top of it.

# Useful references
https://bosh.io/docs/init-aws/  
https://fabianlee.org/2019/01/12/cloudfoundry-installing-a-bosh-director-on-aws/  
https://ultimateguidetobosh.com/networking/  


# Architecture
![architecture](https://github.com/tedanyao/BOSH-tutorial/blob/master/resources/aws-jumpbox-public-private-subnets.png)

The jumpbox inside EC2 serves as a security entry point of our cloud structure. This allows the BOSH Director and its deployments to operate in a more secure environment.

The DMZ public subnet has a NAT gateway so that the instances in the private subnet can reach the internet. Zookeeper is an application example of deploying using BOSH. The jumpbox sets command and talks to BOSH Director, and BOSH Director deploys VMs with target application in the private subnet.

ps. you may omit the jumpbox, but it may result in connection difficulties to BOSH Director and the deployed VMs because host is not in the same public network. Also, omitting jumpbox is not safe.
https://bosh.io/docs/init-external-ip/

# What is a jumpbox?  
A VM that acts as a single access point for the Director and deployed VMs. For resilience, there should be more than one jump box. Allowing access through jump boxes and disabling direct access to the other VMs is a common security measure.

# Prerequisite
1. Install AWS CLI
https://fabianlee.org/2018/12/16/aws-installing-the-aws-cli-on-ubuntu/

2. Install BOSH CLI v2
https://bosh.io/docs/cli-v2-install/

# AWS setup  
1. Create an Amazon IAM user  

The IAM user credential allows you to access AWS.
a. Set the policy with full EC2 access.
b. Create an new user with this policy.
c. Get the Access Key and Secret Access Key for later use.

ps. you can also use a root user, but it is not as safe.

2. Create a VPC (Virtual Private Cloud)  
It acts as an isolation from the outside public network.

a. Select "VPC with a Single Public Subnet"  
b. Fill in the parameters  
![VPC settings](https://github.com/tedanyao/BOSH-tutorial/blob/master/resources/create-vpc.png)  
c. Create an elastic IP  
It is used as the entry point for this VPC.

d. Create a key pair
Create a key pair (*.pem) in this account for an user.  

e. Create a security group
A security group under an VPC is like a separate firewall. Inbound & outbound rules are set in a security group. For example, one can set TCP with only port 3000 allowed.

# Create a jumpbox server (better to have, not mandatory)
* If using a jumpbox server, we can first login to jumpbox and then deploy BOSH director on the same VPC.  
* Otherwise, we should expose the BOSH director's ip address by assiging a public ip, so that the client outside the VPC can access it.  
https://bosh.io/docs/init-external-ip/  
Please add the two arguments into the ```bosh create-env``` script.  
```
bosh create-env bosh-deployment/bosh.yml \
    -o ... \
    -o bosh-deployment/external-ip-with-registry-not-recommended.yml \
    -v ... \
    -v external_ip=12.34.56.78
```

# Deploy BOSH Director
1. Clone Director templates
```
git clone https://github.com/cloudfoundry/bosh-deployment
```

2. Fill below variables (replace example values) and deploy the Director
```
bosh create-env bosh-deployment/bosh.yml \
    --state=state.json \
    --vars-store=creds.yml \
    -o bosh-deployment/aws/cpi.yml \
    -v director_name=bosh-1 \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v access_key_id=AKI... \
    -v secret_access_key=wfh28... \
    -v region=us-east-1 \
    -v az=us-east-1a \
    -v default_key_name=bosh \
    -v default_security_groups=[bosh] \
    --var-file private_key=~/Downloads/bosh.pem \
    -v subnet_id=subnet-ait8g34t
```

3. Connect to Director
```
# Configure local alias
bosh alias-env bosh-1 -e 10.0.0.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)

# Log in to the Director
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`

# Query the Director for more info
bosh -e bosh-1 env
```

# Deploy an application through jumpbox
1. SSH into jumpbox  
2. run ```bosh deploy ...``` to deploy an application with *.yml  

* check the OS version of the Director, and find the same version of that application; otherwise it will hang...  

