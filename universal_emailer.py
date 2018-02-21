#!/usr/bin/env python3
# Universal Emailer
# v0.1, Send Email with Attachment file. modified to send 'result_set.log' file
# Later will be modified to take arguments as input
# This script runs everyday based on cron schedules /etc/cron.d/universal_emailer
# Created date: 2017/11/17

import os
import boto3
import datetime
import logging
import schedule
import time
import sys
from bs4 import BeautifulSoup
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

def send_email():
    # ./universal_emailer.py [recipient] [attachment] [title] [body_text] [body_html]
    
    SENDER = "WhaTap Service <service@whatap.io>"
    CHARSET = "utf-8"
    DATETIME_STRING = str(datetime.datetime.today())
    DEFAULT_RECIPIENT = "service@whatap.io"
    DEFAULT_ATTACHMENT = ""
    DEFAULT_TITLE = DATETIME_STRING + " Uni. Noti. Emailer: " + str(os.uname()[1])
    DEFAULT_BODY_TEXT = "Universal Notification Emailer v0.3,\r\nPlease see the attached file."
    DEFAULT_BODY_HTML = "<html><head></head><body><h1>Universal Notification Emailer v0.3</h1><p>Created for WhaTap Internal Purposes</p><p>Please see the attached file.</p><p>Version 0.0.3</p></body></html>"

    recipient = DEFAULT_RECIPIENT
    attachment = DEFAULT_ATTACHMENT
    title = DEFAULT_TITLE
    body_text = DEFAULT_BODY_TEXT
    body_html = DEFAULT_BODY_HTML

        recipient = sys.argv[1]
    if len(sys.argv) > 1:
        logging.info(DATETIME_STRING + ': Recipient - ' + recipient)
        if len(sys.argv) > 2:
            attachment = sys.argv[2]
            logging.info(DATETIME_STRING + ': Attachment - ' + attachment)
            if len(sys.argv) > 3:
                title = sys.argv[3]
                logging.info(DATETIME_STRING + ': Title - ' + title)
                if len(sys.argv) > 4:
                    body_text = sys.argv[4]
                    logging.info(DATETIME_STRING + ': Body Text - ' + body_text)
                    if len(sys.argv) > 5:
                        with open(sys.argv[5], 'r') as file:
                            body_html = file.read().replace('\n','')
                        logging.info(DATETIME_STRING + ': Body Text - ' + body_html)
                        
    '''
    2. Boto3 & MIME Setting
    '''
    # Create a new SES resource and specify a region.
    client = boto3.client('ses',region_name="us-west-2")

    # Create a multipart/mixed parent container.
    msg = MIMEMultipart('mixed')
    # Add subject, from and to lines.
    msg['Subject'] = DATETIME_STRING + " Uni. Noti. Emailer: " + str(os.uname()[1])
    msg['From'] = SENDER
    msg['To'] = recipient
    msg['cc'] = 
    msg['bcc'

    # Create a multipart/alternative child container.
    msg_body = MIMEMultipart('alternative')

    # Encode the text and HTML content and set the character encoding. This step is
    # necessary if you're sending a message with characters outside the ASCII range.
    textpart = MIMEText(body_text.encode(CHARSET), 'plain', CHARSET)
    htmlpart = MIMEText(body_html.encode(CHARSET), 'html', CHARSET)

    # Add the text and HTML parts to the child container.
    msg_body.attach(textpart)
    msg_body.attach(htmlpart)

    # Attach the multipart/alternative child container to the multipart/mixed
    # parent container.
    msg.attach(msg_body)

    # If there is an attachment,
    # define the attachment part and encode it using MIMEApplication.
    if attachment is not None or attachment != '':
        try:
            att = MIMEApplication(open(attachment, 'rb').read())
            logging.info(DATETIME_STRING + ': Successfully attached file')
            att.add_header('Content-Disposition','attachment',filename=os.path.basename(attachment))
            # Add the attachment to the parent container.
            msg.attach(att)
        except FileNotFoundError as err:
            logging.warning(DATETIME_STRING + ': FileNotFoundError - File not found. Sending without any attachment')

    # Add a header to tell the email client to treat this part as an attachment,
    # and to give the attachment a name.

    try:
        #Provide the contents of the email.
        response = client.send_raw_email(
            Source=SENDER,
            Destinations=[
                recipient
            ],
            RawMessage={
                'Data':msg.as_string(),
            },
            # ConfigurationSetName=CONFIGURATION_SET
        )
    # Display an error if something goes wrong.
    except ClientError as err:
        logging.warning(DATETIME_STRING + ': ClientError. ' + err.response['Error']['Message'])
    else:
        logging.info(DATETIME_STRING + ': Email Sent. Message ID: ' + response['ResponseMetadata']['RequestId'])

    logging.info('Email was Successfully Sent')


if __name__ == "__main__":
    send_email()
    


# Scheduling Logic
#schedule.every().day.at("10:00").do(send_log)
#schedule.run_pending()
#time.sleep(1)

# Input Logic
# def load_attachment():
#     try:
#         attachment = input('[Attach File]: ')
#     except EOFError as err:
#         logging.warning(DATETIME_STRING + ': ' + err + '. No file was selected. Sending without any attachments')
#         attachment = ''
#     return attachment

# else:
#     recipient = input('[Recipient]: ')
#     if recipient is None or recipient == '':
#         recipient = 'service@whatap.io'
#     logging.info(DATETIME_STRING + ': Recipient - ' + recipient)
#     attachment = load_attachment()
        