# AI Agent Commands

This document provides a comprehensive list of commands that the AI agent can execute within the Agentic IDE.

## File Operations

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `open_file` | Opens a file in the editor | `path`: File path | `open_file("src/components/App.js")` |
| `create_file` | Creates a new file | `path`: File path, `content`: File content | `create_file("src/utils/helpers.js", "export const formatDate = (date) => {...}")` |
| `update_file` | Updates an existing file | `path`: File path, `content`: New content, `position`: Line number or range | `update_file("src/App.js", "import React from 'react';", 1)` |
| `delete_file` | Deletes a file | `path`: File path | `delete_file("src/unused.js")` |
| `rename_file` | Renames a file | `oldPath`: Current file path, `newPath`: New file path | `rename_file("src/old.js", "src/new.js")` |
| `list_files` | Lists files in a directory | `path`: Directory path, `filter`: Optional glob pattern | `list_files("src/components", "*.js")` |

## Code Intelligence

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `find_references` | Finds all references to a symbol | `symbol`: Symbol name | `find_references("UserComponent")` |
| `go_to_definition` | Navigates to symbol definition | `symbol`: Symbol name | `go_to_definition("fetchData")` |
| `find_implementations` | Finds all implementations of an interface | `interface`: Interface name | `find_implementations("UserRepository")` |
| `search_codebase` | Searches for text across codebase | `query`: Search string, `options`: Search options | `search_codebase("TODO:", { caseSensitive: false })` |
| `get_type_info` | Gets type information for a symbol | `symbol`: Symbol name | `get_type_info("user")` |

## Project Management

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `create_project` | Creates a new project | `name`: Project name, `template`: Optional template | `create_project("my-app", "react")` |
| `install_dependency` | Installs a dependency | `name`: Package name, `version`: Optional version | `install_dependency("axios", "^0.21.1")` |
| `remove_dependency` | Removes a dependency | `name`: Package name | `remove_dependency("unused-package")` |
| `run_script` | Runs a package.json script | `script`: Script name | `run_script("test")` |
| `run_tests` | Runs tests for a file or directory | `path`: File or directory path | `run_tests("src/components/__tests__")` |

## Git Operations

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `git_init` | Initializes a git repository | None | `git_init()` |
| `git_clone` | Clones a repository | `url`: Repository URL | `git_clone("https://github.com/user/repo.git")` |
| `git_add` | Stages files for commit | `paths`: File paths | `git_add(["file1.js", "file2.js"])` |
| `git_commit` | Commits staged changes | `message`: Commit message | `git_commit("Add new feature")` |
| `git_push` | Pushes commits to remote | `remote`: Remote name, `branch`: Branch name | `git_push("origin", "main")` |
| `git_pull` | Pulls changes from remote | `remote`: Remote name, `branch`: Branch name | `git_pull("origin", "main")` |
| `git_checkout` | Checks out a branch | `branch`: Branch name | `git_checkout("feature/new-ui")` |
| `git_create_branch` | Creates a new branch | `branch`: Branch name | `git_create_branch("feature/auth")` |
| `git_merge` | Merges branches | `source`: Source branch, `target`: Target branch | `git_merge("feature/auth", "main")` |

## Database Operations

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `db_query` | Executes a database query | `query`: SQL query, `params`: Query parameters | `db_query("SELECT * FROM users WHERE id = $1", [123])` |
| `db_migrate` | Runs database migrations | `direction`: 'up' or 'down', `steps`: Number of migrations | `db_migrate("up", 1)` |
| `db_seed` | Seeds the database with test data | `file`: Seed file path | `db_seed("seeds/development.js")` |
| `db_create_table` | Creates a database table | `name`: Table name, `schema`: Table schema | `db_create_table("products", {...})` |

## Debugging

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `set_breakpoint` | Sets a breakpoint | `file`: File path, `line`: Line number | `set_breakpoint("src/App.js", 42)` |
| `remove_breakpoint` | Removes a breakpoint | `file`: File path, `line`: Line number | `remove_breakpoint("src/App.js", 42)` |
| `start_debugging` | Starts debugging session | `config`: Debug configuration | `start_debugging({ program: "src/index.js" })` |
| `step_over` | Steps over in debugger | None | `step_over()` |
| `step_into` | Steps into in debugger | None | `step_into()` |
| `step_out` | Steps out in debugger | None | `step_out()` |
| `continue_debugging` | Continues execution | None | `continue_debugging()` |
| `stop_debugging` | Stops debugging session | None | `stop_debugging()` |

## Terminal Operations

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `run_command` | Runs a terminal command | `command`: Command string | `run_command("npm install")` |
| `open_terminal` | Opens a new terminal | None | `open_terminal()` |
| `clear_terminal` | Clears terminal output | None | `clear_terminal()` |

## Environment Management

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `set_env_var` | Sets an environment variable | `name`: Variable name, `value`: Variable value | `set_env_var("NODE_ENV", "development")` |
| `get_env_var` | Gets an environment variable | `name`: Variable name | `get_env_var("NODE_ENV")` |
| `load_env_file` | Loads environment variables from file | `path`: File path | `load_env_file(".env.local")` |

## AI Assistant Functions

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `generate_code` | Generates code from description | `description`: Code description, `language`: Programming language | `generate_code("A function that sorts an array", "javascript")` |
| `explain_code` | Explains a code snippet | `code`: Code snippet | `explain_code("const result = array.filter(item => item > 10)")` |
| `optimize_code` | Optimizes a code snippet | `code`: Code snippet, `criteria`: Optimization criteria | `optimize_code("function slow() {...}", "performance")` |
| `refactor_code` | Refactors code | `code`: Code snippet, `pattern`: Refactoring pattern | `refactor_code("...", "extract-method")` |
| `suggest_tests` | Suggests tests for code | `code`: Code snippet | `suggest_tests("function add(a, b) { return a + b; }")` |

## Documentation

| Command | Description | Parameters | Example |
|---------|-------------|------------|---------|
| `generate_docs` | Generates documentation | `path`: File or directory path, `format`: Doc format | `generate_docs("src/utils/", "jsdoc")` |
| `update_readme` | Updates README file | `content`: New content, `section`: Section to update | `update_readme("...", "Installation")` |
| `create_api_docs` | Creates API documentation | `endpoints`: API endpoints | `create_api_docs([...])` |

## Best Practices

When using these commands, follow these best practices:
- **Security**: Avoid executing arbitrary code or queries from untrusted sources
- **Backups**: Create backups before making significant changes
- **Testing**: Test changes in a development environment first
- **Documentation**: Document any changes made with these commands
- **Error Handling**: Always handle potential errors from command execution 