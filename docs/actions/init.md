## Get EC2 instance memory usage
> [!NOTE]
> Workflows -> [init.yaml](../../.github/workflows/init.yaml)

## Need setting
### Service list
- EC2
- IAM
- VPC

#### EC2
Need "SSM Agent" -> Default installed in Amazon Linux
  
#### VPC
##### Inbound
Accept HTTPS(443)
##### Outbound
Accept all

#### IAM
- For session manager
    - Policy : AmazonSSMManagedInstanceCore
- For github actions
    - (Optional)
