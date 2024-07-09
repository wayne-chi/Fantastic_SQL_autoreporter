from datetime import datetime, timedelta  # date time
import mysql.connector  # mysql connector

import smtplib

from email.message import EmailMessage

import os

import ssl


db = mysql.connector.connect(
  host="localhost",
  user="root",
  password="psswd",
  database="db"
)

cursor = db.cursor()

param1_value = datetime.today().strftime('%Y-%m-%d')

cursor.callproc("create_summary_timestamped_views", (param1_value,))

cursor.close()
db.close()


td = datetime.today().strftime('%m_%Y')
attachment_path = os.path.join(r"C:\ProgramData\MySQL\MySQL Server 8.0\Uploads",f"summary_data_{td}.csv") # Replace with your file path



def send_email_with_attachment(sender_email, sender_password, recipient_email, subject, body, attachment_path):
    # Create the em message
    em = EmailMessage()
    em['From'] = sender_email
    em['To'] = recipient_email
    em['Subject'] = subject

    # Attach the body of the email to the MIME message
    em.set_content(body)
    context = ssl.create_default_context()

    # Open the file to be sent
    filename = os.path.basename(attachment_path)
    with open(attachment_path, "rb") as attachment:
        dt = attachment.read()
    em.add_attachment(dt, maintype = 'text',
                      subtype ='csv', filename = filename)

    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context = context) as smtp:
        smtp.login(sender_email, sender_password)
        smtp.sendmail(sender_email, recipient_email, em.as_string())




# Usage example
sender_email =  "sending mail@gmail.com"
    
sender_password = "16 letters code"
    
recipient_email = "receiving mail "

lm =(datetime.today() - timedelta(days =2)).strftime('%B')    ## last month
subject = f"Summary Mail for the month of {lm}"
    
body = f"Please find attached the monthly summary for {lm}"
    

send_email_with_attachment(sender_email, sender_password, recipient_email, subject, body, attachment_path)


