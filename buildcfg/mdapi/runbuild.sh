#!/bin/sh

# Run code quality checks
echo "STEP 1 >> Running some code quality checks"
tox -e black
tox -e flake8
tox -e isort

# Uncomment the following lines to run unit tests
# echo "STEP 2 >> Running some unit tests"
# tox -e py38
# tox -e py39
# tox -e py310
echo "STEP 2 >> Skipping the unit tests"

# Run vulnerability tests
echo "STEP 3 >> Running vulnerability tests"
tox -e bandit

# Check project configuration validity
echo "STEP 4 >> Checking project configuration validity"
rm -rf poetry.lock
poetry config virtualenvs.create false
poetry check
poetry install
