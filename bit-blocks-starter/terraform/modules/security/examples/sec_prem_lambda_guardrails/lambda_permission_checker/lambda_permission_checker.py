import boto3
import json
import re
from datetime import datetime

lambda_client = boto3.client('lambda')
iam_client = boto3.client('iam')
cloudwatch = boto3.client('cloudwatch')
log_client = boto3.client('logs')

LOG_GROUP = "/aws/lambda/guardrails"
METRIC_NAMESPACE = "Bluebit/Security"
METRIC_NAME = "OverPermissiveLambdaCount"

def is_overpermissive(policy_doc):
    """Returns True if a policy document has overly permissive actions or resources"""
    statements = policy_doc.get("Statement", [])
    if not isinstance(statements, list):
        statements = [statements]
    for stmt in statements:
        actions = stmt.get("Action", [])
        resources = stmt.get("Resource", [])
        if isinstance(actions, str):
            actions = [actions]
        if isinstance(resources, str):
            resources = [resources]
        if "*" in actions or "*" in resources:
            return True
    return False

def log_to_cloudwatch(message):
    timestamp = int(datetime.utcnow().timestamp() * 1000)
    stream_name = "lambda-permission-checker-stream"

    # Create log stream if doesn't exist
    try:
        log_client.create_log_stream(logGroupName=LOG_GROUP, logStreamName=stream_name)
    except log_client.exceptions.ResourceAlreadyExistsException:
        pass

    log_client.put_log_events(
        logGroupName=LOG_GROUP,
        logStreamName=stream_name,
        logEvents=[
            {
                "timestamp": timestamp,
                "message": message
            }
        ]
    )

def lambda_handler(event, context):
    paginator = lambda_client.get_paginator('list_functions')
    over_count = 0
    flagged_functions = []

    for page in paginator.paginate():
        for function in page['Functions']:
            func_name = function['FunctionName']
            role_arn = function['Role']
            role_name = role_arn.split('/')[-1]

            # Get inline policies
            inline_policies = iam_client.list_role_policies(RoleName=role_name)['PolicyNames']
            for policy_name in inline_policies:
                policy_doc = iam_client.get_role_policy(RoleName=role_name, PolicyName=policy_name)['PolicyDocument']
                if is_overpermissive(policy_doc):
                    flagged_functions.append(func_name)
                    log_to_cloudwatch(f"[OverPermissiveLambdaDetected] {func_name} with inline policy: {policy_name}")
                    over_count += 1
                    break  # no need to check further if one is flagged

            # Check attached managed policies
            attached_policies = iam_client.list_attached_role_policies(RoleName=role_name)['AttachedPolicies']
            for policy in attached_policies:
                arn = policy['PolicyArn']
                default_version_id = iam_client.get_policy(PolicyArn=arn)['Policy']['DefaultVersionId']
                policy_doc = iam_client.get_policy_version(
                    PolicyArn=arn,
                    VersionId=default_version_id
                )['PolicyVersion']['Document']
                if is_overpermissive(policy_doc):
                    flagged_functions.append(func_name)
                    log_to_cloudwatch(f"[OverPermissiveLambdaDetected] {func_name} with attached policy: {policy['PolicyName']}")
                    over_count += 1
                    break

    # Push to CloudWatch metric
    cloudwatch.put_metric_data(
        Namespace=METRIC_NAMESPACE,
        MetricData=[
            {
                'MetricName': METRIC_NAME,
                'Timestamp': datetime.utcnow(),
                'Value': over_count,
                'Unit': 'Count'
            }
        ]
    )

    return {
        'statusCode': 200,
        'body': json.dumps({
            'flagged_lambda_functions': flagged_functions,
            'count': over_count
        })
    }
