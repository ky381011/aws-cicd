# Static Website Files

This directory contains static website files that will be deployed on ECS.

## File Structure

- `index.html` - Home page
- `about.html` - About page

## Deployment Flow

When the EC2 instance starts, the `user_data.sh` script:
1. Clones this repository
2. Copies files from `src/ecs/static/` to `/var/www/html`
3. Nginx container accesses the files via volume mount

## Updating Files

1. Edit HTML files in this directory
2. Push changes to GitHub
3. Launch a new EC2 instance to deploy the latest files

To update an existing instance:
```bash
ssh ec2-user@<instance-ip>
cd /tmp
git clone <repository-url>
cp -r aws-cicd/src/ecs/static/* /var/www/html/
```
