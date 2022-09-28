import boto3

# Mit boto3 wird direkt auf die AWS-Umgebung zugegriffen

# Keine Zugriffsberechtigung in AWS Learner Lab

# IAM --> Users --> Add user (acces Key - Programmatic access) --> Next:Permission --> Attach existing policies (AdministratorAccess)  --> Next:Tags --> Next:Reviews --> Create User
# "aws configure" in der Bash und hier die Keys eingeben.
client = boto3.resource('s3')
bucket = client.Bucket('bucketTag')
bucket.objects.all().delete()
bucket.object_versions.delete()
