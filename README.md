# nzc-regresiontesting-cci

CumulusCI project for regression testing.

## Setup

1. Install CumulusCI: `pipx install cumulusci`
2. Clone this repository
3. Connect to your org: `cci org connect <org_name>`

## Usage

### Create a scratch org
```bash
cci flow run dev_org --org dev
```

### Run tasks
```bash
cci task run <task_name> --org <org_name>
```

### List available tasks and flows
```bash
cci task list
cci flow list
```

## Project Structure

- `force-app/` - Salesforce metadata
- `config/` - Scratch org definitions and other config files
- `cumulusci.yml` - CumulusCI project configuration

