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