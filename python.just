set dotenv-load

PACKAGE_NAME := env_var("PACKAGE_NAME")

PYTHON_VERSION := env_var_or_default("PYTHON_VERSION", "3.8")
TESTS_RUNNER := env_var_or_default("TESTS_RUNNER", "pytest")

PACKAGING_TOOL := if path_exists(invocation_directory() / "Pipfile") == "true" { "pipenv" } else { "poetry" }

VENV_TOOL := "python" + PYTHON_VERSION + " -m venv"
VIRTUAL_ENV := ".venv"

PIP := VIRTUAL_ENV / "bin" / "pip"
PIPENV := VIRTUAL_ENV / "bin" / "pipenv"
POETRY := VIRTUAL_ENV / "bin" / "poetry"
ISORT := VIRTUAL_ENV / "bin" / "isort"
BLACK := VIRTUAL_ENV / "bin" / "black"
FLAKE8 := VIRTUAL_ENV / "bin" / "flake8"
MYPY := VIRTUAL_ENV / "bin" / "mypy"
TEST := VIRTUAL_ENV / "bin" / TESTS_RUNNER

@_help:
    just --list

# Display some justfile vars values
@debug_vars:
    echo "PYTHON_VERSION: {{PYTHON_VERSION}}"
    echo "VENV_TOOL: {{VENV_TOOL}}"
    echo "VIRTUAL_ENV: {{VIRTUAL_ENV}}"
    echo "PACKAGING_TOOL: {{PACKAGING_TOOL}}"
    echo "TESTS_RUNNER: {{TESTS_RUNNER}}"
    echo "PACKAGE_NAME: {{PACKAGE_NAME}}"

# Create/Update the development environment
develop:
    @{{ if path_exists(VIRTUAL_ENV) == "true" { "" } else { "just _create_venv" } }}
    @just _ensure_{{PACKAGING_TOOL}}
    @just _{{PACKAGING_TOOL}}_develop

_pipenv_develop:
    {{PIPENV}} sync --dev

_poetry_develop:
    {{POETRY}} install

_create_venv:
    {{VENV_TOOL}} {{VIRTUAL_ENV}}
    {{PIP}}  install -U pip

_ensure_pipenv:
    {{ if path_exists(PIPENV) == "true" { "" } else { PIP + " install pipenv" } }}

_ensure_poetry:
    {{ if path_exists(POETRY) == "true" { "" } else { PIP + " install poetry" } }}

# Lock project dependencies
lock:
    @just _{{PACKAGING_TOOL}}_lock

_pipenv_lock:
    {{PIPENV}} lock

_poetry_lock:
    {{POETRY}} lock

# Format code
format: sort_imports
    {{BLACK}} {{PACKAGE_NAME}}

# Format code: sort import only
sort_imports:
    {{ISORT}} {{PACKAGE_NAME}}

# Run all tests
test:
    {{TEST}}

# Check code types, style and format
lint: check_types check_style check_format

# Check code typing
check_types: _ensure_mypy
    {{MYPY}} --install-types --non-interactive {{PACKAGE_NAME}}

_ensure_mypy:
    {{ if path_exists(MYPY) == "true" { "" } else { "just develop" } }}

# Check code styling
check_style: _ensure_flake8
    {{FLAKE8}} {{PACKAGE_NAME}}

_ensure_flake8:
    {{ if path_exists(FLAKE8) == "true" { "" } else { "just develop" } }}

# Check code formating
check_format: _ensure_isort _ensure_black
    {{ISORT}} --check {{PACKAGE_NAME}}
    {{BLACK}} --check {{PACKAGE_NAME}}

_ensure_isort:
    {{ if path_exists(ISORT) == "true" { "" } else { "just develop" } }}

_ensure_black:
    {{ if path_exists(BLACK) == "true" { "" } else { "just develop" } }}