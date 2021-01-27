v2.0 
10/19/2020

Terraform files 

To launch with Terraform on GCP a Check Point R80.40 Cloudguard Instance 

By CB Currier <ccurrier@checkpoint.com>

This template will at this time create a gateway with 2 network interfaces. 
When completed the gateway will be sic'd as a gateway only and ready for policy push.
A public IP address will be returned at completion.

Needed: 

1. copy the SSH user public identity file cp_admin_auth_key 
   or rename the variable in vars.tf ssh_pub_key_file to point to the 
   local user identity file

2. Update in vars.tf the service account email address to one that has permissions to access GCP APIS

3. Update the file terraform-admin.json with GCP IAM credentials for the email account in #2.

4. Update export.sh with credentials information that will be needed by terraform. This then
   will need to be executed to push the information into the user env. Alternatively copy the export 
   commands with valid credentials and paste in user file ~/.bashrc. When logging in this data will be 
   part of the user environment.   

5. update the vars.tf file with relevant project name and update other fields as desired.

6. Be sure there is ssh access to public GCP addresses as post impage deployment requires this.

7. Run terraform init

8. Run terraform plan

9. If all is good run terraform apply - answer yes

10. if you need to remove - run terraform destroy. 