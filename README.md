# Rehably Mini Project

Rehably is a healthcare support application built as a login-first, database-backed mini project with a patient portal, doctor dashboard, appointment booking flow, and rehabilitation resource library. The frontend keeps the original visual design while the backend adds authentication, authorization, and persistent patient/doctor workflows.

## Overview

This project combines:

- A static HTML/CSS/JavaScript frontend that preserves the original aesthetic
- A Java Spring Boot backend with session-based authentication
- MySQL storage for users, doctors, appointment requests, and educational resources
- Role-based access for patients and doctors
- A dedicated resources page for exercise and equipment guidance

## Project Structure

```text
rehably/
├─ index.html                     # Login page (default entry)
├─ patient-home.html              # Post-login patient landing page
├─ doctor-dashboard.html          # Doctor-only dashboard
├─ appointments.html             # Patient appointment history
├─ services.html                 # 25-doctor directory and appointment booking UI
├─ resources.html                # Exercise and equipment library
├─ style.css                     # Shared styling
├─ backend/
│  └─ rehably-api/
│     ├─ pom.xml                 # Maven configuration
│     └─ src/main/java/...       # Spring Boot application code
├─ database/
│  └─ mysql-schema.sql           # MySQL schema and seed data
└─ README.md
```

## Tech Stack

- Frontend: HTML, CSS, Vanilla JavaScript
- Backend: Java 17, Spring Boot 3.4.0, Spring Security, Spring Data JPA
- Database: MySQL 8.x (primary), H2 fallback for quick bootstrapping
- Build tool: Maven

## Local Setup

### 1. Prerequisites

- Java 17+
- Maven 3.9+
- MySQL 8.x running locally
- Git / VS Code terminal

### 2. Create the database

Open MySQL and run:

```sql
CREATE DATABASE IF NOT EXISTS rehably_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

You can use your preferred MySQL user (for example `root` or a dedicated app user). Make sure the user has privileges on `rehably_db`.

### 3. Configure environment variables

From the backend project folder, set the database connection before running the app:

```powershell
cd backend\rehably-api
$env:DB_URL = 'jdbc:mysql://localhost:3306/rehably_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC'
$env:DB_USERNAME = 'root'
$env:DB_PASSWORD = 'your_mysql_password'
$env:DB_DRIVER = 'com.mysql.cj.jdbc.Driver'
```

If you want to use a different MySQL user account, replace the values above accordingly.

### 4. Run the backend

```powershell
cd backend\rehably-api
mvn spring-boot:run
```

The app starts on:

- http://localhost:8081

The frontend is served from the project root, so the app entry point is:

- http://localhost:8081/

### 5. Optional: use H2 for quick testing

If MySQL is not available temporarily, you can override the datasource at startup:

```powershell
$env:DB_URL = 'jdbc:h2:mem:rehably;MODE=MySQL;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE'
$env:DB_USERNAME = 'sa'
$env:DB_PASSWORD = ''
$env:DB_DRIVER = 'org.h2.Driver'
$env:HIBERNATE_DIALECT = 'org.hibernate.dialect.H2Dialect'
```

This is useful for local testing, but the main intended setup is MySQL.

## Demo Accounts

The app is seeded with the following default credentials:

- Patient: `patient` / `1234`
- Doctor: `doctor` / `123`

The doctor account is mapped to `DOC001`, which is the doctor used for the doctor dashboard flow.

## Core Features

### Patient flow

- Login with patient credentials
- Redirect to patient dashboard/home
- View healthcare services and doctor directory
- Book an appointment with any doctor in the 25-doctor list
- View the patient’s appointment history

### Doctor flow

- Login with doctor credentials
- Redirect to the doctor dashboard
- View only appointment requests assigned to the authenticated doctor
- Update request status such as pending, accepted, declined, or completed

### Resources

- Browse exercises, educational recovery content, and equipment guidance
- Filter by resource type/category
- Learn safety and usage tips before starting a routine

## Database Notes

The backend uses JPA and seeds basic data automatically when the database is empty. The SQL file at `database/mysql-schema.sql` contains the full MySQL schema and seed inserts for reference.

If you want to initialize the database manually, run the script after creating the database:

```bash
mysql -u root -p rehably_db < database/mysql-schema.sql
```

## API Endpoints

These endpoints are part of the app API:

- `POST /api/auth/login` — authenticate user
- `POST /api/auth/logout` — end session
- `GET /api/auth/me` — current logged-in user
- `GET /api/doctors` — list doctors
- `GET /api/resources` — list resources
- `POST /api/appointment-requests` — create patient appointment request
- `GET /api/appointment-requests/my` — patient appointment history
- `GET /api/doctor/appointments` — doctor-owned appointment queue
- `PATCH /api/appointment-requests/{id}/status` — update appointment status

## Testing

Run the backend test suite with:

```powershell
cd backend\rehably-api
mvn test
```

## Notes

- The app intentionally preserves the original frontend design and extends it rather than redesigning it.
- The default route is the login page, so users must authenticate before accessing role-specific pages.
- The MySQL config is the intended production/local setup; the H2 settings are a fallback for bootstrap-friendly testing.

## Project Status

The repository is built as a working healthcare mini-project with seeded authentication, doctor listing, appointment booking, doctor dashboard enforcement, and resource pages.
