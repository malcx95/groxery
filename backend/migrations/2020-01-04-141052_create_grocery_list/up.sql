CREATE TABLE grocery_lists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE grocery_list_entries (
    id SERIAL PRIMARY KEY,
    list_id SERIAL REFERENCES grocery_lists(id),
    priority INTEGER NOT NULL,
    grocery_id SERIAL REFERENCES groceries(id)
);
