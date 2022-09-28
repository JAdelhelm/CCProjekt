# Wir haben uns dazu entschlossen, nur die Dienste zu implementieren, 
# welche innerhalbder AWS-LearnLab Umgebung zulässig sind.

## Zum Starten unseres Projekts sind folgende Schritte notwendig:
1. Schlüsselpaare unter ``settings.tf`` übergeben.
2. terraform init
3. terraform validate
4. terraform plan
5. terraform apply

Falls beim destroyen ein Fehler des S3 Buckets auftrifft, muss hier ganz einfach in AWS unter S3 navigiert und der Bucket geleert werden.

### Wir haben für unser Projekt ausschließlich nur die Dokumentation von Terraform verwendet.
https://registry.terraform.io/providers/hashicorp/aws/4.16.0/docs