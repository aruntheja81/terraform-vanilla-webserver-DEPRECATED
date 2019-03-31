resource "aws_iam_role" "webapp" {
  name = "${var.namespace}-iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "webapp" {
  name = "${var.namespace}-iam_instance_profile"
  role = "${aws_iam_role.webapp.name}"
}

data "aws_iam_policy_document" "webapp" {
  statement {
      effect = "Allow"
      actions = [
        "s3:*",
        "logs:*",
        "rds:*",
        "ec2:*"
      ]
      resources = [
          "*"
      ] 
  }
}

resource "aws_iam_role_policy" "webapp" {
  name   = "${var.namespace}-iam_role_policy"
  role   = "${aws_iam_role.webapp.name}"
  policy = "${data.aws_iam_policy_document.webapp.json}"
}