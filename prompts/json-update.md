# JSON Update Workflow

Use this workflow when Markdown input contains reliable facts that should update the JSON business database.

## Inputs

- `dashboard/data/members.json`
- `dashboard/data/projects.json`
- `dashboard/data/allocations.json`
- `dashboard/data/capacity.json`
- Relevant files under `input/[Domain]/[ProjectCode]/`
- Latest processed context under `processed/[Domain]/[ProjectCode]/`

## Allowed Updates

- Add or update member aliases.
- Add or update project master data.
- Add or update allocation records using `hoursPerWeek`.
- Add or update leave records.
- Add or update holiday records.

## Rules

- Preserve existing IDs when updating allocation records.
- Generate stable IDs for new allocation records.
- Never delete records unless the user explicitly asks.
- Update `updatedAt` in every JSON file changed.
- Use canonical project folders: `input/[Domain]/[ProjectCode]`.
- Resolve Markdown owners through `members.json` aliases before writing `memberCode`.
- If two interpretations are possible, write the uncertainty into the processed summary instead of overwriting JSON.

## Validation

After editing JSON, run:

```bash
cd dashboard
npm run validate:data
```

Warnings about overload are allowed if they reflect real allocation data. Schema errors, duplicate aliases, broken foreign keys, and invalid canonical folders must be fixed before finishing.

## Output

Write a short update summary to:

```text
processed/[Domain]/[ProjectCode]/json-updates-YYYY-MM-DD.md
```

The summary should include:

- Source Markdown files read.
- JSON files changed.
- Records added or updated.
- Conflicts or low-confidence facts skipped.
