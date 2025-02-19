For non sqlc queries... these might be things like adding a campaign or whatever, basically stuff i would run directly on the DB

Examples:
```sql
-- Actions for a specific session
SELECT * FROM public.user_actions WHERE session_id = X;

-- Anonymous sessions
```sql
-- create db
create database pk_projName owner = "trones" template = "template0" encoding = 'UTF8' lc_collate = 'en_US.utf8' 
lc_ctype = 'en_US.utf8'
```