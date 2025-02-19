-- Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    primary_email TEXT NOT NULL UNIQUE, -- Default/recovery email
    default_username TEXT UNIQUE, -- Main personal username
    first_name TEXT,
    last_name TEXT, 
    password_hash TEXT NOT NULL, -- Encrypted password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

