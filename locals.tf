locals {
  ## The account id
  account_id = data.aws_caller_identity.current.account_id
  # The current partition
  aws_partition = data.aws_partition.current.partition
  # The current region
  region = data.aws_region.current.region

  ## The SQN topic ARN can be provided directly, or it can be computed from the topic name.
  ## If neither is provided, it will be null and SNS notifications will not be sent.
  computed_sns_topic_arn = (
    var.notifications.sns != null && try(var.notifications.sns.topic_name, null) != null
    ? format(
      "arn:%s:sns:%s:%s:%s",
      local.aws_partition,
      local.region,
      local.account_id,
      var.notifications.sns.topic_name
    )
    : null
  )

  ## The SNS topic ARN to use for notifications. This will be the provided
  ## topic ARN, the computed topic ARN, or null if neither is provided.
  notifications_sns_topic_arn = (
    var.notifications.sns == null
    ? null
    : (
      try(var.notifications.sns.topic_arn, null) != null
      ? var.notifications.sns.topic_arn
      : local.computed_sns_topic_arn
    )
  )
}
