provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "backup" {
	bucket = "minecraft-worlds"
	acl = "private"
}

data "aws_iam_policy_document" "backup" {
	statement {
		sid = "1"
		effect = "Allow"
		actions = [
			"s3:*"
		]
		resources = [
			"${aws_s3_bucket.backup.arn}",
			"${aws_s3_bucket.backup.arn}/*"
		]
	}
}

resource "aws_iam_user" "backup" {
  name = "minecraft-backup"
}

resource "aws_iam_user_policy" "backup" {
  name = "minecraft-backup"
  user = "${aws_iam_user.backup.name}"
  policy = "${data.aws_iam_policy_document.backup.json}"
}

resource "aws_iam_access_key" "backup" {
	user = "${aws_iam_user.backup.name}"
}