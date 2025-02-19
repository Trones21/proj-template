-- name: InsertSignupLinkClick :one
INSERT INTO marketing.signup_link_clicks (link, referrer, clicked_at)
VALUES ($1, $2, $3)
RETURNING click_id, clicked_at;