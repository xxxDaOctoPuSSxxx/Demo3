# **Network Module** 

## Previously to run need export AWS account credentials 

*********
 

### In This module I create next AWS resource: 

1. AWS Virtual Private Cloud; 

2. Create 2 subnets (private and public) in each availability zone: 

3. Create an internet gateway from my VPC to global network; 

4. Create a **NAT gateways** in each public subnets for restream traffic from private subnets to global web; 

5. Create **routing table** & writing route rules for all private & public traffic; 

**********
 

### Outputs contains next: 

1. availability zones; 

2. vpc_id; 

3. vpc_cidr; 

4. internet_gateway_id; 

5. public_subnets_id; 

6. subnets_available_zone; 

7. public_subnets_cidr_blok; 

8. private_subnets_id; 

9. private_subnets_cidr_blok. 

**************
 

### Variable contains next: 

1. **owner** - to add owner in tags of AWS resource; 

2. **project** - to add project name in tags of AWS resource; 

3. **env** - to add environments; 

4. **app_name** - to add app_name in tags; 

5. **vpc_cidr** - to set CIDR_BLOCK for VPC; 

6. **az_count** - to set count of availability zones from available pool. 

**************
