resource "aws_sqs_queue" "appointment_scheduled" {
  name = "appointment-scheduled"
}

resource "aws_sqs_queue" "email_sent" {
  name = "email-sent"
}