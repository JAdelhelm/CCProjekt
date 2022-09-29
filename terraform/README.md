# Wir haben uns in diesem Ordner dazu entschlossen, nur die Dienste zu nutzen, welche in der AWS-Learner-Lab Umgebung zulässig sind.

## Zum Starten unseres Projekts sind folgende Schritte notwendig:
1. Schlüsselpaare unter ``settings.tf`` übergeben.
2. ``terraform init``
3. ``terraform validate``
4. ``terraform plan``
5. ``terraform apply``

Falls beim destroyen ein Fehler des S3 Buckets auftrifft, muss hier ganz einfach in AWS unter S3 der Bucket geleert werden.
- Löschen des Inhalts des S3 Buckets mit `aws s3 rm s3://<BUCKET_NAME> --recursive`
- BUCKET_NAME muss entsprechend der einzigartig erstelle Bucketname sein

# Quellen
-  Wir haben für dieses Projekt (terraform Ordner) ausschließlich nur die Terraform-Doku verwendet.
    - https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs
