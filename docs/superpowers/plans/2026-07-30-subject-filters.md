# Subject Filters Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the subject index name and position filters and name/team/position sorting functional through URL-backed LiveView state.

**Architecture:** `SubjectManager.Subjects.list_subjects/1` will build and execute an Ecto query for filtering and sorting. `SubjectManagerWeb.SubjectLive.Index` will handle URL parameters, update the form through `phx-change`, and assign query results to the page. Tests will use `has_element?/2` and subject DOM IDs instead of raw HTML assertions.

**Tech Stack:** Elixir, Phoenix LiveView, Ecto, SQLite, ExUnit, Phoenix.LiveViewTest.

## Global Constraints

- Name filtering is case-insensitive and uses a partial match.
- Position filtering matches the selected enum value exactly.
- Sorting is ascending by `name`, `team`, or `position`.
- Filter state is represented in URL query parameters.
- Invalid position and sort values are ignored.
- Do not add pagination, debouncing, descending sort controls, or unrelated UI changes.

---

### Task 1: Add filtered subject queries

**Files:** Modify `lib/subject_manager/subjects.ex`; test `test/subject_manager/subjects_test.exs`.

**Interface:** Add `SubjectManager.Subjects.list_subjects/1`, accepting `%{q: binary, position: atom | nil, sort_by: atom | nil}` and returning subjects. Keep `list_subjects/0` delegating to `list_subjects(%{})`.

- [ ] Write failing context tests under `describe "list_subjects/1"` for case-insensitive partial name matching, exact position matching, and ascending sorting by name, team, and position.
- [ ] Run `mix test test/subject_manager/subjects_test.exs`; expected failure is that `list_subjects/1` does not exist.
- [ ] Implement the Ecto query with `ilike`, exact position filtering, and an allow-listed ascending `order_by`.
- [ ] Rerun the context tests and confirm they pass.

### Task 2: Connect filter form and URL parameters to the LiveView

**Files:** Modify `lib/subject_manager_web/live/subject_live/index.ex` and `lib/subject_manager_web/live/subject_live/index.html.heex`; test `test/subject_manager_web/live/subject_live/index_test.exs`.

**Interface:** Consume URL parameters `q`, `position`, and `sort_by`. Add `handle_params/3`, `handle_event("filter", params, socket)`, and filter form state that patches `/subjects` with current values.

- [ ] Add failing LiveView tests under `describe "handle_params/3"` and `describe "handle_event/3"` for name filtering, position filtering, sorting by all three fields, and reset navigation.
- [ ] Assert subject cards only through `has_element?/2` and `refute has_element?/2`.
- [ ] Run `mix test test/subject_manager_web/live/subject_live/index_test.exs`; expected failure is that filter events are not handled.
- [ ] Implement `handle_params/3` to validate parameters, call `Subjects.list_subjects/1`, and assign `form: to_form(params, as: :filter)`.
- [ ] Implement `handle_event("filter", params, socket)` with `push_patch/2`, add `phx-change="filter"` and `phx-submit="filter"`, and keep reset linked to `/subjects`.
- [ ] Rerun the LiveView tests and confirm all filter, sorting, mount, and reset tests pass.

### Task 3: Verify the complete feature

**Files:** No additional files expected.

- [ ] Run `mix test` and confirm zero failures.
- [ ] Run `mix format --check-formatted` and `git diff --check`.
- [ ] Run `git status --short` and `git diff --stat`; confirm changes are limited to subject filtering, LiveView behavior, and tests.
