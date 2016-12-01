#!/bin/bash -e

bundle install --path vendor/bundle
bundle exec rspec
