# Fantastic_SQL_autoreporter
Fantastic_SQL_autoreporter is a powerful tool that automates the process of pulling data from a SQL database and sending a summary report to a specified email account. This project leverages SQL, Python, and Task Scheduler to ensure the report is sent out on the first of every month.

## Features
- **Automated Data Extraction**: Uses Sql procedures, dynamic SQL, and views to pull the necessary data.
- **EMail Delivery**: utilizes Pythons 'smtplib' , 'email' annd 'ssl' libraries t send the summary report via mail
- **Scheduled Execution**: Employs Task Scheduler to automate the process ensuring timely delivery of the report.

## Components
### SQL : 
- **Procedures**: Predefined SQL procedure to handle complex data extraction logic 
- **dynamic sql**: Dynammically generated SQL queries to varying data extraction requirements
- **views**: To simplify the data retrieval process and help other non SQL experts have a quick view

### Python
- **Mysql connector**: Connects to the mysql database to execute the SQL procedure
- **smtplib**: sends emails using the Simple Mail Transfer Protocol
- **email**: construct messages with attachments
- **ssl**: Secure the connection to the email server

### Task scheduler
- **Automated Scheduling**: Schedules task to be sent on the first of every month, ensuring the summary report is generated and sent without manual intervention.


## Prerequisite
- MySQL database with the necessary table ( a sample table "accounts.csv") is provided.
- Python 3.x
- Mysql connector
- Task scheduler
- 
## Setup
- Clone the repository
- Install Python dependency
  - pip install mysql-connector
- Configure the mysql db
  - ensure that you have your database running
- Configure Python script
  - ensure to put your email, username, and password where necessary.
-  create a  bat script to run the Python code
- configure the task scheduler

## Usage
One setup, the Task scheduler will automatically run the Python script on the specified schedule.
The script will :
1. connect to the mysql database
2. execute the necessary procedure with the input argument
3. SQL will produce the summary in a csv
4. send the CSV files as an email attachment to a specified recipient.


## Contributions 
Contributions are welcome. Feel free to fork the repo and send a pull request with your changes.
