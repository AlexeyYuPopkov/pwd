#!/bin/sh
echo '-----------------'
echo 'Upload android beta app'
echo '-----------------'

cd android

bundle install

bundle exec fastlane upload_android_beta_app

cd ..

echo '-----------------'
echo 'Upload android beta app. end'
echo '-----------------'