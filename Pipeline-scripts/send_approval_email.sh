#!/bin/bash

# Configuration
PIPELINE_NAME="your-pipeline-name"
STAGE_NAME="ApprovalStage"
ACTION_NAME="EmailApproval"
REGION="ap-south-1"
APPROVER_EMAIL="sumitphotosbackup48@gmail.com"
EC2_PUBLIC_IP="your.ec2.public.ip"

# Get approval token and execution ID
TOKEN=$(aws codepipeline get-pipeline-state \
  --name $PIPELINE_NAME \
  --region $REGION \
  --query "stageStates[?stageName=='$STAGE_NAME'].actionStates[?actionName=='$ACTION_NAME'].latestExecution.token" \
  --output text)

EXECUTION_ID=$(aws codepipeline get-pipeline-state \
  --name $PIPELINE_NAME \
  --region $REGION \
  --query "stageStates[?stageName=='$STAGE_NAME'].latestExecution.pipelineExecutionId" \
  --output text)

# Approval links
APPROVE_LINK="http://$EC2_PUBLIC_IP/approve?token=$TOKEN&pipeline=$PIPELINE_NAME&stage=$STAGE_NAME&action=$ACTION_NAME&execution_id=$EXECUTION_ID"
REJECT_LINK="http://$EC2_PUBLIC_IP/reject?token=$TOKEN&pipeline=$PIPELINE_NAME&stage=$STAGE_NAME&action=$ACTION_NAME&execution_id=$EXECUTION_ID"

# Send email via SES
aws ses send-email --from "$APPROVER_EMAIL" \
  --destination "ToAddresses=$APPROVER_EMAIL" \
  --message "Subject={Data=EC2 Stop Approval Request},Body={Html={Data=\
  <h3>Approval Needed to Stop EC2</h3>\
  <p>Click below to approve or reject:</p>\
  <p><a href='$APPROVE_LINK'>✅ Approve</a> &nbsp;&nbsp; <a href='$REJECT_LINK'>❌ Reject</a></p>}}" \
  --region $REGION
