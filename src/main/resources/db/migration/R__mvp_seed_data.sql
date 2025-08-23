-- This file is used to seed initial data into the database.
-- Ensure the database is empty before running this script.

-- USERS
INSERT INTO users (username, hashed_password, email, role, first_name, middle_name, last_name, provider)
VALUES
('user01', '$2a$12$z0xmm/0lJH4MGGmaCjWobOoaOnQe/2H2GJMtjGCz9ctJa77UEE19W', 'user01@example.com', 'USER', 'Alice', NULL, 'User', 'LOCAL'), -- Password: User@123
('moderator01', '$2a$12$bmO1W0KqlW6Dujdhi3Xe1eNjwL/8TvgDV4Cg4XhF7v62wGiucxqLC', 'moderator01@example.com', 'MODERATOR', 'Bob', NULL, 'Mod', 'LOCAL'), -- Password: Moderator@123
('admin01', '$2a$12$mic4.JVbhElG4/7dO7bzSuYNePadzv4M8US3Y.6NFuF4nTzgMBEL2', 'admin01@example.com', 'ADMIN', 'Carol', NULL, 'Admin', 'LOCAL'); -- Password: Admin@123

-- USER_AVATARS
INSERT INTO user_avatars (user_id, version, url, source)
VALUES
(1, 1, 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice', 'DICEBEAR'),
(2, 1, 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob', 'DICEBEAR'),
(3, 1, 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carol', 'DICEBEAR');

-- Update users to set avatar_id based on user_avatars
UPDATE users
SET avatar_id = (
    SELECT ua.id
    FROM user_avatars ua
    WHERE ua.user_id = users.id
    ORDER BY ua.id ASC
    LIMIT 1
);

-- GENRES
INSERT INTO genres (name, added_by_user_id)
VALUES
('Science Fiction', 2),
('Fantasy', 2),
('Romance', 3),
('Non-fiction', 2),
('Adventure', 1),
('Mystery', 3),
('Biography', 1);

-- BOOKS
INSERT INTO books (title, author, published_year, description, added_by_user_id)
VALUES
('Dune', 'Frank Herbert', 1965, 'Epic sci-fi about politics and power.', 1),
('1984', 'George Orwell', 1949, 'Dystopian novel about surveillance.', 2),
('The Hobbit', 'J.R.R. Tolkien', 1937, 'A hobbit goes on an unexpected journey.', 3),
('The Da Vinci Code', 'Dan Brown', 2003, 'Mystery thriller involving secret societies and puzzles.', 2),
('Steve Jobs', 'Walter Isaacson', 2011, 'Biography of the Apple co-founder.', 3);

-- BOOK_GENRES
INSERT INTO book_genres (book_id, genre_id)
VALUES
(1, 1), -- Dune: Science Fiction
(1, 5), -- Dune: Adventure
(2, 1), -- 1984: Science Fiction
(2, 4), -- 1984: Non-fiction
(3, 2), -- The Hobbit: Fantasy
(3, 5), -- The Hobbit: Adventure
(4, 6), -- The Da Vinci Code: Mystery
(4, 5), -- The Da Vinci Code: Adventure
(5, 7); -- Steve Jobs: Biography

-- REVIEWS
INSERT INTO reviews (content, rating, reviewer_id, book_id)
VALUES
('A masterpiece of science fiction.', 5, 1, 1),
('Thought-provoking and chilling.', 4, 2, 2),
('A thrilling ride full of puzzles and twists.', 4, 3, 4),
('An insightful look into the life of a tech legend.', 5, 1, 5);

-- REVIEW_VOTES
INSERT INTO review_votes (review_id, user_id, vote_type)
VALUES
(1, 2, 'UPVOTE'),
(2, 3, 'UPVOTE'),
(3, 1, 'UPVOTE'),
(4, 2, 'UPVOTE');
