layout_poetry() {
  if [[ ! -f pyproject.toml ]]; then
    log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
    exit 2
  fi

  local VENV=$(poetry env list --full-path | cut -d' ' -f1)
  if [[ -z $VENV || ! -d $VENV/bin ]]; then
    log_error 'No created poetry virtual environment found.  Use `poetry install` to create one first.'
    exit 2
  fi
  VENV=$VENV/bin
  export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
  export POETRY_ACTIVE=1
  PATH_add "$VENV"
}
