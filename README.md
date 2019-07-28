# Deploy one PA VM-Series on AWS using Terraform

This skillet deploys a single VM-Series on AWS with 3 interfaces (Management, Untrust, Trust), with a public IP attached to the management and untrust interfaces. In addition an Ubuntu linux webserver is deployed in the Trust subnet to showcase the deployment

VM-Series Firewall Credentials:
Username: admin
Password: pal0alt0

# Support Policy
The code and templates in the repo are released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.

# Troubleshooting
The first time you deploy this project, you may get an error that you need to 'Opt In' to the Ubuntu or Palo Alto Networks VM-Series licensing agreement. Just follow the link provided to accept the agreement, wait 3-4 minutes, then try again.