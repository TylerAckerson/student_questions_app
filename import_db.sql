DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255),
  author_id VARCHAR(255) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  parent_reply_id INTEGER REFERENCES replies(id),
  author_id VARCHAR(255) REFERENCES users(id),
  body VARCHAR(255)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

/* Seeding the database */
INSERT INTO
  users (fname, lname)
VALUES
  ('eric', 'schwarz'), ('ryan', 'glass'), ('jade', 'mchp');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('I have a question', 'how does this work?', 1),
  ('I have another question', 'does this work?', 2),
  ('Roll call!', 'Who is here?', 2);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
VALUES
  (1, NULL, 2, 'Good point'), (1, 1, 1, 'I see'),
  (1, 2, 2, 'Really good point'), (1, 2, 2, 'Replying to reply');

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (2,1), (3,1), (2,2), (1,1), (1,2);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2,2), (1,1), (3,2), (1,2), (3,1);
