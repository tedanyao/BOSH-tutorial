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


