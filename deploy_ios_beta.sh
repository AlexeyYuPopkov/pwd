#!/bin/sh
echo '-----------------'
echo 'Upload ios beta app'
echo '-----------------'

cd ios

# bundle install

bundle exec fastlane upload_ios_beta_app

cd ..

echo '-----------------'
echo 'Upload ios beta app. end'
echo '-----------------'