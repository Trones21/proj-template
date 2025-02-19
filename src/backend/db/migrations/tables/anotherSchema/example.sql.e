CREATE TABLE example (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    attended_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
