# 📚 Book Review Hub - Backend

![Java](https://img.shields.io/badge/Java-21-blue)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.4-success)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Build](https://img.shields.io/badge/Build-passing-brightgreen)

This is the backend service for **Book Review Hub**, a web application that allows users to review, rate, and discover books.

It provides a RESTful API for managing users, books, genres, and reviews, with authentication and authorization features.

---

## 🗂️ Table of Contents

- [🚀 Basic Features](#-basic-features)
- [🧱 Tech Stack](#-tech-stack)
- [📂 Project Structure](#-project-structure)
- [⚙️ Configuration](#-configuration)
- [🛠️ Set Up Database](#-set-up-database)
- [▶️ Run the Application](#-run-the-application)
- [📬 API Documentation](#-api-documentation)
- [📋 Planned Features (under evaluation)](#-planned-features-under-evaluation)
- [🛠️ Features Implemented at MVP Stage](#-features-implemented-at-mvp-stage)
- [🧩 Future Improvements (unevaluated features)](#-future-improvements-unevaluated-features)
- [📄 License](#-license)

---

## 🚀 Basic Features

- ✅ User registration & login.
- ✅ Role-based access control (account, moderator, admin).
- ✅ Book management with genres.
- ✅ Book reviews and rating system.
- ✅ Review voting (upvote/downvote).
- ✅ Validation and error handling.
- ✅ Secure password hashing and authentication.
- ✅ RESTful API design.
- ✅ Database versioning with Flyway (development only).
---

## 🧱 Tech Stack

| Layer           | Technology                       |
|-----------------|----------------------------------|
| Language        | Java 21                          |
| Framework       | Spring Boot 3.4.4                |
| Build Tool      | Maven                            |
| Database        | MySQL (Railway)                  |
| ORM             | Spring Data JPA (Hibernate)      |
| Migration Tool  | Flyway                           |
| Auth            | Spring Security + JWT            |
| Validation      | Bean Validation (Hibernate)      |
| Development     | Lombok, Spring DevTools          |
| Deployment      | Render.com (Backend)             |

---

## 📂 Project Structure

_**(MVP Stage)**_

```
bookreviewhub-backend/
├── .gitattributes
├── .gitignore
├── mvnw
├── mvnw.cmd
├── pom.xml
├── README.md
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/
    │   │       └── bookreviewhub/
    │   │           └── backend/
    │   │               ├── BookReviewHubApplication.java
    │   │               ├── common/                                             # Share the whole application
    │   │               │   ├── dto/
    │   │               │   │   └── response/
    │   │               │   │       ├── ErrorResponse.java
    │   │               │   │       └── SuccessResponse.java
    │   │               │   ├── exception/
    │   │               │   │   └── GlobalExceptionHandler.java
    │   │               │   └── security/
    │   │               │       ├── jwt/
    │   │               │       │	└── JwtService.java
    │   │               │       ├── filter/
    │   │               │       │	└── JwtAuthenticationFilter.java
    │   │               │       └── handler/
    │   │               │			├── CustomAccessDeniedHandler.java
    │   │               │			└── CustomAuthenticationEntryPoint.java
    │   │               ├── config/
    │   │               │   ├── JwtConfig.java
    │   │               │   └── SecurityConfig.java
    │   │               ├── auth/
    │   │               │   ├── controller/
    │   │               │   │   └── AuthController.java
    │   │               │   ├── dto/
    │   │               │   │   ├── request/
    │   │               │   │   │   ├── LoginRequest.java
    │   │               │   │   │   └── RegisterRequest.java
    │   │               │   │   └── response/
    │   │               │   │       └── AuthResponse.java
    │   │               │   ├── entity/
    │   │               │   │   └── User.java
    │   │               │   ├── repository/
    │   │               │   │   └── UserRepository.java
    │   │               │   └── service/
    │   │               │       ├── AuthService.java
    │   │               │       └── CustomUserDetailsService.java
    │   │               └── testapi/
    │   │                   └── controller/
    │   │                       └── TestController.java
    │   │
    │   └── resources/
    │       ├── application.properties
    │       ├── application-dev.properties
    │       ├── application-prod.properties
    │       ├── static                                                          # (currently empty)
    │       ├── templates                                                       # (currently empty)
    │       └── db/
    │           └── migration/
    │               ├── R__mvp_seed_data.sql
    │               └── V1__init_schema.sql
    └── test/
        └── com/
            └── bookreviewhub/
                └── backend/
                    └── ...
```

---

## ⚙️ Configuration

Environment-specific configurations are defined in:

- `src/main/resources/application.properties`
- `src/main/resources/application-dev.properties`
- `src/main/resources/application-prod.properties`

Profiles:

| Profile | File                        | Used for           | Flyway         | Hibernate           |
|---------|-----------------------------|--------------------|----------------|---------------------|
| dev     | application-dev.properties  | Local development  | Auto-migrate   | validate            |
| prod    | application-prod.properties | Production         | No migration   | validate            |
| test    | application-test.properties | Testing (Optional) | Manual or none | create-drop or none |

> [!Note]
> In production, Flyway migrations are not applied automatically.
> Always `set spring.jpa.hibernate.ddl-auto=validate` to ensure schema integrity.

---

## 🛠️ Prerequisites

- Java 21
- Maven 3.8+
- MySQL 8.0+ database (locally or via a cloud provider like Railway)
- (Optional) Docker (for containerization, future support planned)

---

## 🛠️ Set Up Database

### 1. Create Database

- Create a MySQL database, e.g., bookreviewhub_db.
- (Optional) Host on Railway or any MySQL provider.

### 2. (Development only) Apply Schema
   
- The initial schema is available at src/main/resources/db/migration/V1__init_schema.sql (any other schema will be placed here).
- Flyway will automatically apply migrations in dev profile when the app starts.

Or you can manually import the SQL file if needed.

### 3. Entity Relationship Diagram for this project
_Coming soon (under preparation)_

---

## ▶️ Run the Application

### 1. Clone the repository

```bash
git clone https://github.com/tlavu2004/bookreviewhub-backend.git
cd bookreviewhub-backend
```

### 2. Build the application

```bash
./mvnw clean install -DskipTests
```
_or_
```bash
mvn clean package
```

### 3. Run the application

Using Maven:

```bash
./mvnw spring-boot:run "-Dspring-boot.run.profiles=dev" 
```
Or use IntelliJ / VSCode Spring Boot run configuration.

> [!Note]
> - Replace dev with prod or any another profile name as needed.
> - When using Flyway, new migration scripts (if any) will be automatically applied to your database, tracked by the flyway_schema_history table.

### 4. Optional Commands:

- Reset database (development only):

```bash
./mvnw flyway:clean

# Apply migrations manually (in development)
./mvnw flyway:migrate "-Dspring-boot.run.profiles=dev"
```

> [!Warning]
> - This will drop all tables and reapply migrations.
> - Never run this in production!

---

## 📬 API Documentation

Swagger UI is **configured** but **not yet deployed**.  
It will be available soon at:

```http
http://localhost:8080/swagger-ui/index.html
```
_(Coming soon)_

### 🔐 Authentication

- This project uses JWT (JSON Web Tokens) for authentication.
- After registering or logging in via `/api/auth/login`, you will receive a JWT token.
- Use this token in the `Authorization` header for all protected endpoints:

```bash
Authorization: Bearer <your-token-here>
```

_(Authentication endpoints are fully functional for MVP stage)_

---

## 📋 Planned Features (under evaluation)

✅

| No. | Feature Description                               | Importance | Complexity | Roles                                            | Done |
|-----|---------------------------------------------------|------------|------------|--------------------------------------------------|------|
| 1   | Login                                             | 5/5        | Easy       | All                                              |      |
| 2   | Register                                          | 5/5        | Easy       | Users                                            |      |
| 3   | Add books (edit if account is the owner)             | 4/5        | Medium     | All                                              |      |
| 4   | View book details                                 | 5/5        | Easy       | All                                              |      |
| 5   | Add book to favorites (bookmark)                  | 4/5        | Medium     | All                                              |      |
| 6   | Write a review                                    | 5/5        | Medium     | All                                              |      |
| 7   | Star rating                                       | 4/5        | Medium     | All                                              |      |
| 8   | Upvote/Downvote reviews                           | 3/5        | Medium     | All                                              |      |
| 9   | View others' reviews                              | 5/5        | Easy       | All                                              |      |
| 10  | Manage review history (delete if needed)          | 3/5        | Medium     | All (except users who did not create the review) |      |
| 11  | Search books by name                              | 5/5        | Easy       | All                                              |      |
| 12  | Filter by genre, author, etc.                     | 3/5        | Hard       | All                                              |      |
| 13  | Pagination                                        | 3/5        | Medium     | All                                              |      |
| 14  | View, edit and approve reviews                    | 4/5        | Medium     | Moderators, Admins                               |      |
| 15  | Manage book list                                  | 4/5        | Medium     | Moderators, Admins                               |      |
| 16  | Manage review list                                | 4/5        | Medium     | Moderators, Admins                               |      |
| 17  | View account list                                    | 3/5        | Easy       | Admins                                           |      |
| 18  | View account details                                 | 3/5        | Medium     | Admins                                           |      |
| 19  | Manage books (remove or edit inappropriate books) | 4/5        | Medium     | Moderators, Admins                               |      |
| 20  | View stats (books, members count, etc.)           | 3/5        | Hard       | Admins                                           |      |
| 21  | Manage reviews (edit/delete any reviews)          | 5/5        | Medium     | Moderators, Admins                               |      |
| 22  | Ban/Unban Users                                   | 4/5        | Hard       | Admins                                           |      |

---

## 🛠️ Features implemented at MVP Stage

| No. | Feature Description                   |
|-----|---------------------------------------|
| 1   | Login                                 |
| 2   | Register                              |
| 3   | Add books (edit if account is the owner) |
| 4   | View book details                     |
| 6   | Write a review                        |
| 9   | View others' reviews                  |
| 11  | Search books by name                  |

---

## 🧩 Future Improvements (unevaluated features)
- Email confirmation when registering.
- Full-text search for books and authors.
- Report abusive reviews.
- Insert images into reviews.
- User promotion/demotion features.
- Statistics dashboard for admins.
- ...

---

## 📄 License
This project is under the MIT License.
