#!/bin/bash

# Configuration
INSTANCE_ID="i-0123456789abcdef0"
REGION="ap-south-1"

echo "Stopping EC2 instance: $INSTANCE_ID in $REGION..."
aws ec2 stop-instances --instance-ids $INSTANCE_ID --region $REGION
