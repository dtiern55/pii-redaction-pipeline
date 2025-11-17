resource "aws_iam_role" "lambda_exec" {
  name = "${var.bucket_prefix}-${var.environment}-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]

  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy for S3 access
resource "aws_iam_role_policy" "lambda_s3" {
  role = aws_iam_role.lambda_exec.id
  
  policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${local.input_bucket_name}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${local.output_bucket_name}/*"
      }
    ]
  })
}