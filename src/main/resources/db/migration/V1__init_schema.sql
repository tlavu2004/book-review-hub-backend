/* ACCOUNTS */
CREATE TABLE IF NOT EXISTS accounts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role ENUM('USER', 'MODERATOR', 'ADMIN') DEFAULT 'USER',
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) DEFAULT NULL,
    last_name VARCHAR(50) NOT NULL,
    provider ENUM('LOCAL', 'GOOGLE', 'FACEBOOK') DEFAULT 'LOCAL',
    provider_id VARCHAR(255) DEFAULT NULL,
    avatar_id BIGINT UNSIGNED DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login_at DATETIME DEFAULT NULL,
    updated_at DATETIME DEFAULT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE',
    banned_at DATETIME DEFAULT NULL,
    deactivated_at DATETIME DEFAULT NULL,

    CONSTRAINT uq_provider_provider_id UNIQUE (provider, provider_id),
    FOREIGN KEY (avatar_id) REFERENCES account_avatars(id) ON DELETE SET NULL,

    INDEX idx_created_at (created_at)
);

/* Trigger for "accounts" table */
DELIMITER //
CREATE TRIGGER trg_accounts_before_update
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//
DELIMITER ;

/* ACCOUNT_AVATARS */
CREATE TABLE IF NOT EXISTS account_avatars (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    version INT UNSIGNED NOT NULL,
    url VARCHAR(1023) NOT NULL,
    source ENUM('CLOUDINARY', 'DICEBEAR', 'OAUTH2') NOT NULL DEFAULT 'CLOUDINARY',
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,

    UNIQUE KEY uq_account_version (account_id, version),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,

    INDEX idx_account_uploaded_at (account_id, uploaded_at DESC)
);

DELIMITER //
CREATE TRIGGER trg_account_avatars_before_update
BEFORE UPDATE ON account_avatars
FOR EACH ROW
BEGIN
    SET NEW.uploaded_at = NOW();
END;
//
DELIMITER ;

/* BOOKS */
CREATE TABLE IF NOT EXISTS books (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year YEAR,
    publisher VARCHAR(255),
    cover_image_url VARCHAR(511) DEFAULT NULL,
    description TEXT,
    added_by_account_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    deleted_at DATETIME DEFAULT NULL,

    CONSTRAINT uq_title_author UNIQUE (title, author),
    FOREIGN KEY (added_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL,

    INDEX idx_added_by_account (added_by_account_id),
    INDEX idx_created_at (created_at)
);

/* Trigger for "books" table */
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
CREATE TABLE IF NOT EXISTS book_images (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT UNSIGNED NOT NULL,
    image_url VARCHAR(1024) NOT NULL,
    type ENUM('COVER', 'ILLUSTRATION', 'AUTHOR', 'OTHER') DEFAULT 'OTHER',
    uploaded_by_account_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    deleted_at DATETIME DEFAULT NULL,

    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL,

    INDEX idx_book_id (book_id),
    INDEX idx_type (type),
    INDEX idx_uploaded_by_account (uploaded_by_account_id)
);

/* Trigger for "book_images" table */
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
CREATE TABLE IF NOT EXISTS genres (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    added_by_account_id BIGINT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    deleted_at DATETIME DEFAULT NULL,

    FOREIGN KEY (added_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL,

    INDEX idx_created_at (created_at),
    INDEX idx_added_by_account (added_by_account_id)
);

/* Trigger for "genres" table */
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
CREATE TABLE IF NOT EXISTS book_genres (
    book_id BIGINT UNSIGNED,
    genre_id BIGINT UNSIGNED,
    deleted_at DATETIME DEFAULT NULL,

    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE,

    INDEX idx_genre_id (genre_id) /* For filtering all books in the same genre */
);

/* REVIEWS */
CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    rating TINYINT UNSIGNED CHECK (rating BETWEEN 1 AND 5),
    reviewer_id BIGINT UNSIGNED NOT NULL,
    book_id BIGINT UNSIGNED NOT NULL,
    previous_review_id BIGINT UNSIGNED DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,

    FOREIGN KEY (reviewer_id) REFERENCES accounts(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (previous_review_id) REFERENCES reviews(id) ON DELETE SET NULL,

    INDEX idx_account_book_time (reviewer_id, book_id, created_at DESC),
    INDEX idx_book_id (book_id),
    INDEX idx_reviewer_id (reviewer_id)
);

/* REVIEW_VOTES (N-N relationship) */
CREATE TABLE IF NOT EXISTS review_votes (
    review_id BIGINT UNSIGNED,
    account_id BIGINT UNSIGNED,
    vote_type ENUM('UPVOTE', 'DOWNVOTE'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME DEFAULT NULL,

    PRIMARY KEY (review_id, account_id),
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,

    INDEX idx_account_id (account_id),
    INDEX idx_created_at (created_at)
);