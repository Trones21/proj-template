SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'public' OR table_schema = 'marketing'
  --AND table_type = 'BASE TABLE';
