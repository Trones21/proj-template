
-- name: GetUserByID :one
SELECT user_id, primary_email, default_username, first_name, last_name, created_at
FROM users
WHERE user_id = $1;


-- name: GetUserByEmail :one
SELECT user_id, primary_email, default_username, first_name, last_name, created_at
FROM users
WHERE primary_email = $1;


-- name: GetAllUsers :many
SELECT user_id, primary_email, default_username, first_name, last_name, created_at
FROM users
ORDER BY created_at DESC;


-- name: CreateUser :one
INSERT INTO users (primary_email, default_username, password_hash, first_name, last_name)
VALUES ($1, $2, $3, $4, $5)
RETURNING user_id, primary_email, default_username, first_name, last_name, created_at;


-- name: UpdateUser :exec
UPDATE users
SET primary_email = $2,
    default_username = $3,
    password_hash = $4,
    first_name = $5,
    last_name = $6
WHERE user_id = $1;


-- name: DeleteUser :exec
DELETE FROM users
WHERE user_id = $1;


-- name: SearchUsersByName :many
SELECT user_id, primary_email, default_username, first_name, last_name, created_at
FROM users
WHERE first_name ILIKE '%' || $1 || '%'
   OR last_name ILIKE '%' || $1 || '%'
   OR default_username ILIKE '%' || $1 || '%'
ORDER BY created_at DESC;
