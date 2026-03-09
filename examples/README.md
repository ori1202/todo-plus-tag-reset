# Examples

## sample.todo

Example Todo+ file matching the routine-plan architecture:

- **Parent section** (e.g. `routine Plan:`) — top-level header, no `@daily`
- **@daily subsections** — indented under parent, format `@daily Name (Description):`
- **Tasks** — time-block format: `☐ HH:MM - HH:MM → Task description`
- **Unicode**: ☐ (empty), ✔ (done), ✘ (cancelled)
- **Time tags**: `@started`, `@done`, `@cancelled`, `@lasted`, `@wasted`

## sample_log.txt

Example log output after running the script on `sample.todo`. Completed, cancelled, and in-progress tasks from `@daily` sections are recorded before reset.

## Try it

```powershell
.\reset_daily.ps1 -TodoFilePath ".\examples\sample.todo" -LogFilePath ".\examples\my_log.txt"
```
