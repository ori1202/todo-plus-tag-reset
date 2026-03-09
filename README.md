# todo-plus-tag-reset

Resets `@daily` tasks in a Todo+ file and logs completed/cancelled tasks.

## Description

This PowerShell script reads a `.todo` file, finds sections marked with `@daily`, logs any modified tasks (done, cancelled, or started) to a log file, then resets those tasks to an empty state (☐) and removes time tracking tags.

## Usage

```powershell
.\reset_daily.ps1
```

### Parameters

| Parameter       | Default                                      | Description                    |
|----------------|----------------------------------------------|--------------------------------|
| `TodoFilePath` | `c:\Users\ori88\OneDrive\Desktop\New Text Document.todo` | Path to your .todo file |
| `LogFilePath`  | `c:\Users\ori88\OneDrive\Desktop\daily_todo_log.txt`     | Path to the log file     |

### Example with custom paths

```powershell
.\reset_daily.ps1 -TodoFilePath "C:\path\to\my.todo" -LogFilePath "C:\path\to\daily_log.txt"
```

## Requirements

- PowerShell 5.1 or later
- Todo+ file format with `@daily` section headers
