# 📚 Book Review Hub - Backend

This is the backend service for **Book Review Hub**, a web application that allows users to review, rate, and discover books. It provides a RESTful API for managing users, books, genres, and reviews, including authentication and authorization features using Spring Security.

---

## 🚀 Features

- ✅ User registration & login
- ✅ Role-based access control (user, moderator, admin)
- ✅ Book management with genres
- ✅ Book reviews and rating system
- ✅ Review voting (upvote/downvote)
- ✅ Database migration with Flyway
- ✅ Validation and error handling
- ✅ Secure password hashing & authentication
- ✅ RESTful API design

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

_**This is just a proposed directory structure - Stage: MVP**_

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
    │   │               ├── controller/
    │   │               │   ├── AuthController.java
    │   │               │   ├── BookController.java
    │   │               │   ├── GenreController.java
    │   │               │   ├── UserController.java        
    │   │               │   └── ReviewController.java
    │   │               ├── dto/
    │   │               │   ├── AuthRequest.java
    │   │               │   ├── AuthResponse.java
    │   │               │   ├── BookRequest.java
    │   │               │   ├── BookResponse.java
    │   │               │   ├── BookSummary.java
    │   │               │   ├── GenreRequest.java
    │   │               │   ├── GenreResponse.java
    │   │               │   ├── GenreSummary.java
    │   │               │   ├── UserRequest.java
    │   │               │   ├── UserResponse.java
    │   │               │   ├── UserSummary.java
    │   │               │   ├── ReviewRequest.java
    │   │               │   ├── ReviewResponse.java
    │   │               │   └── ReviewSummary.java
    │   │               ├── model/
    │   │               │   ├── User.java
    │   │               │   ├── Book.java
    │   │               │   ├── Genre.java
    │   │               │   └── Review.java
    │   │               ├── repository/
    │   │               │   ├── UserRepository.java
    │   │               │   ├── BookRepository.java
    │   │               │   └── ReviewRepository.java
    │   │               ├── service/
    │   │               │   ├── AuthService.java
    │   │               │   ├── BookService.java
    │   │               │   ├── GenreService.java
    │   │               │   ├── UserService.java   
    │   │               │   └── ReviewService.java
    │   │               └── security/
    │   │                   ├── JwtFilter.java
    │   │                   ├── JwtUtil.java
    │   │                   └── CustomUserDetailsService.java
    │   └── resources/
    │       ├── application.properties
    │       ├── static
    │       ├── templates
    │       └── db/
    │           └── migration/
    │               └── V1__init.sql
    └── test/
        └── com/
            └── bookreviewhub/
                └── backend/
                    └── ...
```

---

## ⚙️ Configuration

Configure database connection and other environment-specific variables in `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/bookreviewhub_db
spring.datasource.username=root
spring.datasource.password=yourpassword

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true

spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration

# JWT config
app.jwt.secret=YourJWTSecretKey
app.jwt.expiration=86400000
```

---

## 🧪 Run Locally

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/bookreviewhub-backend.git
cd bookreviewhub-backend
```

### 2. Set up MySQL
- Create a database named `bookreviewhub_db` in [Railway](https://railway.com)
- Import schema from `src/main/resources/db/migration/V1__init.sql`
- Let Flyway auto migrate if configured properly
=> Will be available soon.

_**Proposed SQL Schema:**_
```sql
/* USERS */
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role ENUM('USER', 'MODERATOR', 'ADMIN') DEFAULT 'USER',
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    last_name VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE',

    INDEX idx_created_at (created_at) /* Filtering users by created date */
);

/* Trigger for `users` table */
DELIMITER //
CREATE TRIGGER trg_users_before_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//
DELIMITER ;

/* BOOKS */
CREATE TABLE books (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year YEAR,
    publisher VARCHAR(255),
    cover_image_url VARCHAR(511) DEFAULT NULL,
    description TEXT,
    added_by_user_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    is_removed BOOLEAN DEFAULT FALSE,

    CONSTRAINT uq_title_author UNIQUE (title, author),
    FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_added_by_user (added_by_user_id),
    INDEX idx_created_at (created_at)
);

/* Trigger for `books` table */
DELIMITER //
CREATE TRIGGER trg_books_before_update
BEFORE UPDATE ON books
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//
DELIMITER ;

/* BOOK_IMAGES stores multiple images for each book (1-N with books) */
CREATE TABLE book_images (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT UNSIGNED NOT NULL,
    image_url VARCHAR(1024) NOT NULL,
    type ENUM('COVER', 'ILLUSTRATION', 'AUTHOR', 'OTHER') DEFAULT 'OTHER',
    uploaded_by_user_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    is_removed BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by_user_id) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_book_id (book_id),
    INDEX idx_type (type),
    INDEX idx_uploaded_by_user (uploaded_by_user_id)
);

/* Trigger for `book_images` table */
DELIMITER //
CREATE TRIGGER trg_book_images_before_update
BEFORE UPDATE ON book_images
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//
DELIMITER ;

/* GENRES */
CREATE TABLE genres (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    added_by_user_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    is_removed BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_created_at (created_at),
    INDEX idx_added_by_user (added_by_user_id)
);

/* Trigger for `genres` table */
DELIMITER //
CREATE TRIGGER trg_genres_before_update
BEFORE UPDATE ON genres
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//
DELIMITER ;

/* BOOK_GENRES (N-N relationship)*/
CREATE TABLE book_genres (
    book_id BIGINT UNSIGNED,
    genre_id BIGINT UNSIGNED,
    is_removed BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (book_id, genre_id),

    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE,

    INDEX idx_genre_id (genre_id) /* For filtering all books in the same genre */
);

/* REVIEWS */
CREATE TABLE reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    rating TINYINT UNSIGNED CHECK (rating BETWEEN 1 AND 5),
    reviewer_id BIGINT UNSIGNED NOT NULL,
    book_id BIGINT UNSIGNED NOT NULL,
    previous_review_id BIGINT UNSIGNED DEFAULT NULL,
    is_removed BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (previous_review_id) REFERENCES reviews(id) ON DELETE SET NULL,

    INDEX idx_user_book_time (reviewer_id, book_id, created_at DESC),
    INDEX idx_book_id (book_id),
    INDEX idx_reviewer_id (reviewer_id)
);

/* REVIEW_VOTES (N-N relationship) */
CREATE TABLE review_votes (
    review_id BIGINT UNSIGNED,
    user_id BIGINT UNSIGNED,
    vote_type ENUM('UPVOTE', 'DOWNVOTE'),
    is_removed BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id, user_id),

    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
);
```

### 3. Build the application

```bash
./mvnw clean install
```
_or_
```bash
mvn clean package
```

### 4. Run the application

Using Maven:
```bash
./mvnw spring-boot:run
```
Or using IntelliJ / VSCode Spring Boot run.

## 📬 API Documentation 
Will be available soon.
_Planned: Swagger UI at `/swagger-ui.html`_

## 📚 List of features implemented in this project ✅

| No. | Feature Description                               | Importance | Complexity | Roles                                            | Done |
|-----|---------------------------------------------------|------------|------------|--------------------------------------------------|------|
| 1   | Login                                             | 5/5        | Easy       | All                                              |      |
| 2   | Register                                          | 5/5        | Easy       | Users                                            |      |
| 3   | Add books (edit if user is the owner)             | 4/5        | Medium     | All                                              |      |
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
| 17  | View user list                                    | 3/5        | Easy       | Admins                                           |      |
| 18  | View user details                                 | 3/5        | Medium     | Admins                                           |      |
| 19  | Manage books (remove or edit inappropriate books) | 4/5        | Medium     | Moderators, Admins                               |      |
| 20  | View stats (books, members count, etc.)           | 3/5        | Hard       | Admins                                           |      |
| 21  | Manage reviews (edit/delete any reviews)          | 5/5        | Medium     | Moderators, Admins                               |      |
| 22  | Ban/Unban Users                                   | 4/5        | Hard       | Admins                                           |      |

## 🛠️ Feature implemented at MVP Stage
| No. | Feature Description                   |
|-----|---------------------------------------|
| 1   | Login                                 |
| 2   | Register                              |
| 3   | Add books (edit if user is the owner) |
| 4   | View book details                     |
| 6   | Write a review                        |
| 9   | View others' reviews                  |
| 11  | Search books by name                  |

## 🧩 Future Improvements (unevaluated features)
- Email confirmation when registering.
- Full-text search for books and authors.
- Report abusive reviews.
- Promoted/Relegated accounts.
- Insert pictures in your review(s).
- ...

## 📄 License
This project is under the MIT License.
