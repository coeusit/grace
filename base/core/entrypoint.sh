#!/bin/bash
rake db:migrate
rake db:seed
ruby start.rb
