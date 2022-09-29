# Schritte
1. ``IAM --> Users --> Add user (acces Key - Programmatic access) --> Next:Permission --> Attach existing policies (AdministratorAccess)  --> Next:Tags --> Next:Reviews --> Create User``
2. ``aws configure`` und hier die Keys eingeben (Nach Installation der AWS CLI).
3. Die (Git-)Bash Umgebung benötigt ``zip``
   1. https://stackoverflow.com/questions/38782928/how-to-add-man-and-zip-to-git-bash-installation-on-windows
4. Unter dem Ordner ``file_converter`` das Bash Script ``package.sh`` ausführen.

# Ablauf
1. Es soll ein YAML File über einen S3 Bucket hochgeladen werden.
2. Dabei wird eine Hook getriggert, welche mit einer SNS Topic verbunden ist, die ähnlich wie ein Broadcaster funktioniert und die Nachricht einfach an eine SNS Topic weitergibt
3. Die SNS Topic gibt dann anhand eines push/approach die Nachricht an die SQS Queue weiter
   1. Auch nur mit einer SQS Queue umsetzbar, aber nicht sinnvoll, da nicht gut erweiterbar
4. Nach der SQS Queue hängt eine in Python geschriebene Lambda-Funktion (YAML/JSON Converter), welche per pull/approach sich die Messages von der SQS Queue holt
5. Der S3 Bucket benötigt die Erlaubnis in die SNS Topic reinschreiben zu dürfen, dafür muss eine Policy erstellt werden
   1. ``messaging.tf``--> policy (``sns:Pusblish``)
6. Policy anlegen unter AWS --> IAM --> Roels --> Create Role --> AWS service (Lambda) --> Next --> Rolle Name vergeben --> Create Role
7. Create Policy --> JSON 
   1. Einfügen:
   ``
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-central-1:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:*:log-group:/aws/lambda/*:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "sqs:DeleteMessage",
              "sqs:GetQueueAttributes",
              "sqs:ReceiveMessage"
            ],
            "Resource": [
              "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action":[
                "s3:*"
            ],
            "Resource":[
                "arn:aws:s3:::*"
            ]
        }
    ]
  }
  ``
8. Next --> Next --> Policy Namen vergeben --> Create Policy --> Zuvor erzeugte Rolle die Policy hinzufügen
9. Jetzt können die Lambda Funktionen angelegt werden (Hier muss alles in der gleichen Region liegen)
10. Hier den Converter erstellen --> Functions --> Create function
    1.  Use existing role --> Zuvor erstelle Rolle zuordnen
    2.  Funktion wird erstellt und anschließend den Code hochladen --> ``file-converter-v1.0.zip``
11. Handler der Funktion muss ``app.lambda_handler.lambda_handler`` benannt werden (unter ``variables.tf`` zu finden)
12. Kann jetzt unter dem Tab - ``Test`` gestestet werden mit --> ``message_from_sqs_with_raw_del.json``
# Quellen
- Das Messaging wurde mit Hilfe von Online-Lernvideos erstellt