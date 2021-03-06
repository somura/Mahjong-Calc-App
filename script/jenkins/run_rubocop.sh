#!/bin/bash -e

bundle install --path vendor/bundle
bundle exec rubocop \
  --require rubocop/formatter/checkstyle_formatter \
  --format RuboCop::Formatter::CheckstyleFormatter --no-color --rails --out tmp/checkstyle.xml || true
