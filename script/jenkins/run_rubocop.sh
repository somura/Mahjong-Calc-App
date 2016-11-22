#!/bin/bash -e

bundle install --path vendor/bundle
bundle exec ubocop -requirrubocop \
  --require rubocop/formatter/checkstyle_formatter \
  --format RuboCop::Formatter::CheckstyleFormatter -o reports/xml/checkstyle-result.xml \
  --format html -o reports/html/index.html || truerubocop/formatter/checkstyle_formatter --format RuboCop::Formatter::CheckstyleFormatter --no-color --rails --out tmp/checkstyle.xml
