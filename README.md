# ICS344 DVSA Project

##  Overview
This assignment belongs to the ICS-344 (Information Security) class.  
The task entails the deployment and examination of the OWASP Damn Vulnerable Serverless Application (DVSA) in an AWS environment.

This project is intended to cover:
- Vulnerability identification
- Exploitation through real-life techniques
- Implementation of remediation measures
- Reporting of all results

---

##  Architecture
The DVSA is based on the serverless architecture on AWS:

- Frontend - Amazon S3 (Static Website Hosting)
- Backend - API Gateway & AWS Lambda
- Data Store - DynamoDB
- Authentication - Amazon Cognito
- Logging - CloudWatch / CloudTrail

---

##  Access Links

Website (Frontend):
http://dvsa-omaiar-2026-xyz123-249138274075-us-east-1.s3-website.us-east-1.amazonaws.com

API Gateway (Backend):
https://yoqkwmk19l.execute-api.us-east-1.amazonaws.com/Stage

> ⚠️ Warning: The frontend will not operate correctly because of deliberate vulnerabilities.  
>  All testings and exploitations will be carried out via the API endpoint.

---

##  Tools Utilized
- AWS Console
- curl (Command Line Interface)
- CloudWatch Logs
- GitHub
- Google Docs (for collaborative reporting)

---

##  Directory Structure


docs/
└── report/ → Final report files (Word/PDF)

evidence/
└── lesson-XX/ → Screenshots and proof for each lesson

scripts/
└── lesson-XX/ → Commands (curl, etc.)

team/ → Team notes (optional)


---

## Topics Covered

### Finished Lessons
- Lesson 1: Event Injection
- Lesson 2: Broken Authentication
- Lesson 3: Sensitive Data Exposure
- Lesson 4: Insecure Cloud Setup
- Lesson 5: Broken Access Control
- Lesson 6: Denial of Service (DoS)
- Lesson 7: Over-privileged Functions
- Lesson 8: Logic Bugs
- Lesson 9: Dependency Exploitation
- Lesson 10: Unhandled Exceptions

---

## Approach

For each topic:
1. Find the vulnerability
2. Exploit with curl/API
3. Evidence collection (screenshot + logging)
4. Analysis of the root cause
5. Fixing and verification

---

## Team Members
- Omar Alyamani
- Rayan Alharbi
- --
- Ibrahim

---

## Disclaimer
This application is live on a **non-production AWS cloud instance** for educational purposes only.

DVSA is meant to be vulnerable and should not be used maliciously.

---

## Additional Information
- Front-end bugs are expected since DVSA contains vulnerabilities.
- Testing of the back-end is done through API Gateway.
- CloudWatch logging serves as the verification medium.
