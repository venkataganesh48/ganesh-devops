#!/bin/bash

ACTION=$1  # notify or stop

# Configuration
INSTANCE_ID="i-07d9fc2449d1956f3"
TOPIC_ARN="arn:aws:sns:ap-south-1:458799594567:ec2-alert-testing"
REGION="ap-south-1"

if [ "$ACTION" == "notify" ]; then
  echo "Sending approval email..."
  aws sns publish \
    --topic-arn "$TOPIC_ARN" \
    --region "$REGION" \
    --subject "Approval Needed to Stop EC2" \
    --message "Your EC2 instance ($INSTANCE_ID) is running. Please go to AWS CodePipeline and approve the pipeline to stop it."
fi

if [ "$ACTION" == "stop" ]; then
  echo "Stopping EC2 instance $INSTANCE_ID..."
  aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
fi
