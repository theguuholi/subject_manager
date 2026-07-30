# Subject Filters Design

## Goal

Implement the filters on `SubjectManagerWeb.SubjectLive.Index` so users can search subjects by name, filter by position, and sort by name, team, or position.

## Behavior

- Name search uses a case-insensitive partial match against `subjects.name`.
- Position filtering matches the selected subject position exactly.
- Sorting is ascending and supports `name`, `team`, and `position`.
- With no filters selected, subjects are returned without additional filtering or sorting constraints.
- Filter state is represented in URL query parameters so filtered pages can be refreshed or bookmarked.
- Resetting the filters navigates back to `/subjects` without query parameters.

## Architecture

`SubjectManager.Subjects.list_subjects/1` will own filtering and sorting. It will build an Ecto query from a small, explicit options map and execute it through `Repo.all/1`.

`SubjectManagerWeb.SubjectLive.Index` will:

1. Read filter parameters in `handle_params/3`.
2. Convert them into the options expected by `list_subjects/1`.
3. Assign the resulting subjects and form to the socket.
4. Patch the URL when the filter form changes.

Invalid or unknown position and sort values will be ignored, leaving the corresponding filter unset.

## Testing

Add database-backed context tests for:

- Unfiltered subject retrieval.
- Case-insensitive partial name matching.
- Position filtering.
- Sorting by name, team, and position.

Add LiveView tests for:

- Applying name and position filters through the form.
- Applying each sort option.
- Preserving structural assertions through `has_element?/2` and related LiveView helpers instead of raw HTML assertions.

## Scope

This change does not add pagination, debouncing, descending sort controls, or changes to the subject card design.
