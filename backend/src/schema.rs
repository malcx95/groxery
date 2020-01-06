table! {
    groceries (id) {
        id -> Int4,
        name -> Varchar,
        category -> Int4,
        by_weight -> Bool,
    }
}

table! {
    grocery_list_entries (id) {
        id -> Int4,
        list_id -> Int4,
        priority -> Int4,
        grocery_id -> Int4,
    }
}

table! {
    grocery_lists (id) {
        id -> Int4,
        name -> Varchar,
    }
}

joinable!(grocery_list_entries -> groceries (grocery_id));
joinable!(grocery_list_entries -> grocery_lists (list_id));

allow_tables_to_appear_in_same_query!(
    groceries,
    grocery_list_entries,
    grocery_lists,
);
