# Testing and Fixtures Summary

## Key Decisions and Approach

Directory: 
- **fictional_data:**
    - json_payloads: These are the actual payloads that the frontend will send, fixtures **SHOULD NOT** be inserted directly inyto the db. By using the actual API we have made this dual purpose:
        - These serve as integration for any of the endpoints we call!
            - If the fixture loading is broken, then the endpoint is too! 
        - Load test data  
- **static_necessary:** Any data that is simply part of the application, not user data, for example metrics definitions, user_action_categories, etc.
    - This data wont likely wont have endpoints, so direct db access is fine.

### 1. **General Approach**
- The primary goal is to ensure **sequential, end-to-end testing** of API endpoints.
- Tests will simulate real-world API usage by calling endpoints in sequence, capturing necessary data (e.g., `user_id`, `conference_id`) and using it in subsequent requests.
- Avoid unnecessary complexity like parallel execution or mocks; tests will focus on simplicity and reliability.

### 2. **Fixtures Strategy**
- Fixtures represent **JSON request payloads** sent to the back end, not the database entities themselves.
- Fixtures will be managed manually initially to maintain tight control.
  - Example: A fixture for user creation will match the JSON object expected by the API.
  - Example Payload:
    ```json
    {
      "username": "testuser",
      "password": "password123"
    }
    ```

- Automation may be introduced later via small helper functions for common templates (e.g., generating different payloads by replacing key variables).

### 3. **Dynamic ID Handling**
- IDs such as `user_id` and `conference_id` are generated on the back end and must be captured from API responses.
  - After creating a user, the returned `user_id` will be stored and injected into subsequent requests.
  - Example Flow:
    1. **Create User**: Capture `user_id` from the response.
    2. **Create Conference**: Use `user_id` in the request body.

### 4. **Test Runner Design**
- The test runner will execute tests **sequentially** and output status updates to standard output.
- Logging:
  - Each test step will log its result (success or error).
  - Optionally, results can be written to a log file for historical tracking.
- Example pseudocode:
    ```go
    func main() {
        fmt.Println("Starting API tests...")

        userID, err := CreateUserAndFetchID()
        if err != nil {
            fmt.Println("Error creating user:", err)
            os.Exit(1)
        }
        fmt.Println("User created successfully. User ID:", userID)

        err = CreateConferenceWithUserID(userID)
        if err != nil {
            fmt.Println("Error creating conference:", err)
            os.Exit(1)
        }
        fmt.Println("Conference created successfully.")
    }
    ```

### 5. **Handling Multiple User Types and Roles**
- Mini Go applications will cover various user scenarios:
  - **Authenticated Users:** Login, CRUD operations for entities.
  - **Anonymous Users:** Perform similar CRUD operations without login, with expected failures for restricted actions.
  - **Role-Based Actions:** Each role (e.g., admin, viewer, editor) follows similar test flows but with role-specific access controls.
  - **Negative Tests:** These will include cases such as:
    - Attempting actions that are not permitted for the current role.
    - Example: "Editor" trying to delete an entity when only an "Admin" has that permission.

### 6. **Organizing Tests for Clarity**
- **Reusable Flows:** Combine related actions (e.g., user creation, login, conference creation) into cohesive flows within the same test program.
- **Role-Based Files:** Structure files or sections based on roles to keep logic organized (e.g., `auth_tests.go`, `anon_tests.go`, `admin_tests.go`).
- **Generated Tests:** Consider using structured data (e.g., spreadsheet or table) to auto-generate parts of the test suite.
  - Example Table Structure:
    | Role   | Endpoint      | Action     | Expected Result |
    |--------|---------------|------------|----------------|
    | Admin  | /conference   | POST       | 200 OK         |
    | Viewer | /conference   | DELETE     | 403 Forbidden  |

### 7. **Error Handling and Isolation**
- Each endpoint will be tested in sequence, and any failure will immediately log the error and stop execution.
- For debugging, individual tests can be isolated by running only the relevant function.
  - The runner may accept arguments or flags to specify which tests to run.
  - Example:
    ```bash
    ./test-runner --run-specific=create-conference
    ```

### 8. **Potential Improvements**
- Introduce **template-based fixtures**:
  - Example:
    ```json
    {
      "user_id": "{{user_id}}",
      "conference_name": "Intro to GoLang",
      "speaker": "John Doe"
    }
    ```
  - These templates could be dynamically populated during test execution.
- Add **execution time logging** to monitor potential bottlenecks.
- Automate certain workflows with simple Go-based or spreadsheet-driven scripts to reduce boilerplate.

---

## Conclusion
The approach prioritizes simplicity and real-world API testing by focusing on:
1. Sequential test execution for reliability.
2. JSON-based fixtures that map directly to expected request payloads.
3. Dynamic ID capturing to maintain data integrity between dependent requests.
4. Role-based test coverage to ensure access controls work as intended.
5. A lightweight test runner that logs results clearly and can be extended incrementally.

Future optimizations will focus on improving test visibility and potentially automating parts of fixture creation without overcomplicating the system.

