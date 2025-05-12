#!/bin/bash

# AWS SSO Import Helper Script
# Generates Terraform import commands for existing Identity Center configuration
# Requires AWS CLI configured with access to SSO and Identity Store resources

# Retrieve the Identity Center (SSO) instance ARN from AWS
INSTANCE_ARN=$(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text)

# Check if the instance ARN was successfully retrieved
if [ -z "$INSTANCE_ARN" ]; then
  echo "❌ Could not retrieve Identity Center instance ARN. Make sure AWS CLI is configured."
  exit 1
fi

# Confirm the detected Identity Center instance ARN
echo "✅ Using Identity Center Instance ARN: $INSTANCE_ARN"

# Fetch all permission sets associated with the Identity Center instance
echo "\n🔍 Fetching existing permission sets..."
PERMISSION_SETS=$(aws sso-admin list-permission-sets --instance-arn "$INSTANCE_ARN" --query 'PermissionSets' --output text)

# Loop through each permission set and generate a Terraform import command
for PS_ARN in $PERMISSION_SETS; do
  # Get the name of the permission set
  PS_NAME=$(aws sso-admin describe-permission-set \
    --instance-arn "$INSTANCE_ARN" \
    --permission-set-arn "$PS_ARN" \
    --query 'PermissionSet.Name' --output text)

  # Clean up the name to make it a valid Terraform resource name
  RESOURCE_NAME=$(echo $PS_NAME | tr -cd '[:alnum:]_')

  # Print out the Terraform import command for this permission set
  echo "terraform import aws_ssoadmin_permission_set.$RESOURCE_NAME $PS_ARN"
done

# Fetch all account IDs in the AWS Organization
echo "\n🔍 Fetching account assignments..."
ACCOUNTS=$(aws organizations list-accounts --query 'Accounts[*].Id' --output text)

# For each permission set and each account, generate Terraform import commands for assignments
for PS_ARN in $PERMISSION_SETS; do
  for ACCOUNT_ID in $ACCOUNTS; do
    # Get account assignments for this permission set and account
    ASSIGNMENTS=$(aws sso-admin list-account-assignments \
      --instance-arn "$INSTANCE_ARN" \
      --account-id "$ACCOUNT_ID" \
      --permission-set-arn "$PS_ARN" \
      --query 'AccountAssignments' --output json)

    # Loop through each assignment and print the Terraform import command
    echo "$ASSIGNMENTS" | jq -c '.[]' | while read -r row; do
      # Extract principal type and ID from each assignment
      PRINCIPAL_TYPE=$(echo "$row" | jq -r .PrincipalType)
      PRINCIPAL_ID=$(echo "$row" | jq -r .PrincipalId)

      # Construct the composite import ID format required by Terraform
      IMPORT_ID="$INSTANCE_ARN/$ACCOUNT_ID/$PS_ARN/$PRINCIPAL_TYPE/$PRINCIPAL_ID"

      # Print out the Terraform import command for this assignment
      echo "terraform import aws_ssoadmin_account_assignment.assignment_${ACCOUNT_ID}_${PRINCIPAL_ID} \"$IMPORT_ID\""
    done
  done
done
