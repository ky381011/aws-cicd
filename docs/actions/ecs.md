## Create ECS on EC2
> [!NOTE]
> Workflows -> [ecs.yaml](../../.github/workflows/ecs.yaml)

## Need setting

<details><summary>Structure</summary>

```mermaid
graph TB
    subgraph AWS["AWS Cloud"]
        subgraph VPC["VPC (172.16.0.0/20)"]
            subgraph Subnet["Subnet(s)"]
                NIC1["Network Interface 1<br/>(Primary)"]
                NIC2["Network Interface 2+<br/>(Additional)"]
            end
            
            SG["Security Group<br/>- SSH (22)<br/>- HTTP (80)"]
            
            subgraph EC2["EC2 Instance (Amazon Linux 2023)"]
                ECS["ECS Container<br/>Instance"]
            end
        end
        
        subgraph IAM["IAM"]
            Role["Instance Role"]
            Profile["Instance Profile"]
            Policies["Policies<br/>- ECS Service<br/>- SSM Core"]
        end
        
        subgraph Monitoring["CloudWatch"]
            Dashboard["Dashboard<br/>- Network In<br/>- Network Out"]
        end
    end
    
    Internet["Internet"]
    
    Internet -.->|SSH/HTTP| SG
    SG -.-> NIC1
    NIC1 --> EC2
    NIC2 -.->|Attached| EC2
    
    Profile --> EC2
    Role --> Profile
    Policies --> Role
    
    EC2 -->|Metrics| Dashboard
    
    style EC2 fill:#ff9900
    style ECS fill:#ff9900
    style VPC fill:#e3f2fd
    style IAM fill:#fff3e0
    style Monitoring fill:#f3e5f5
```

</details>

```yaml
- name: Terraform Apply
  run: terraform apply -auto-approve
  env:
    TF_VAR_ssh_key_name: "my-custom-key"
    TF_VAR_ssh_public_key: ${{ secrets.SSH_PUBLIC_KEY }}
```