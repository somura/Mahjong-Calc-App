#!/bin/bash -e

bundle install --path vendor/bundle
rubocop
