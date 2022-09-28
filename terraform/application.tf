# Beanstalk, um Applikationen online laufen zu lassen
resource "aws_elastic_beanstalk_application" "application" {
  name        = "Beanstalk-Anwendung"
}

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = "Beanstalk-Umgebung"
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.0.3 running Python 3.7"

  setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name      = "IamInstanceProfile"
        value     = "aws-elasticbeanstalk-ec2-role"
      }
  }