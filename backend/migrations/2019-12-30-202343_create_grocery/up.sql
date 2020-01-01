-- CREATE TYPE grocery_category AS ENUM (
--   'dairy',
--   'meat',
--   'seafood',
--   'colonial',
--   'fruit_or_vegetable',
--   'snacks',
--   'drinks',
--   'frozen',
--   'charcuterie',
--   'hygiene',
--   'other'
-- );

CREATE TABLE groceries (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  category INTEGER NOT NULL,
  by_weight BOOLEAN NOT NULL
);
