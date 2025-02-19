# Repositories Folder

This folder contains database interaction logic that extends or customizes the functionality provided by `sqlc`.

## Purpose

While `sqlc` generates query wrappers directly from SQL files, this folder is used for:

1. **Custom Database Operations**:
   - Logic that involves combining multiple `sqlc` queries.
   - Handling advanced use cases like transactions or custom caching strategies.

2. **Separation of Concerns**:
   - Keeps database-related logic centralized and reusable.
   - Provides an abstraction layer between the service/business logic and the database.

## Usage

- Use the `repositories` folder for any additional DB-related logic not directly handled by `sqlc`.
- For simple CRUD operations, prefer using the `sqlc`-generated methods directly.

## Examples

### Simple Use Case (Use SQLC)
If the generated query is sufficient:
```go
user, err := queries.GetUserByEmail(ctx, email)
```

### Custom Use Case
- In this case we are using a wrapper for the wrappers...
```go
func (r *UserRepository) CreateUserWithAudit(ctx context.Context, user User, audit AuditLog) error {
    tx, err := r.db.BeginTx(ctx, nil)
    if err != nil {
        return err
    }
    defer tx.Rollback()

    // Insert user
    _, err = r.queries.CreateUser(ctx, user)
    if err != nil {
        return err
    }

    // Insert audit log
    _, err = r.queries.InsertAuditLog(ctx, audit)
    if err != nil {
        return err
    }

    return tx.Commit()
}
```