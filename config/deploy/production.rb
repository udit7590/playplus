# List of instances
# 1. Application 1 : 54.252.151.184
# 2. Database(RDS) : 52.62.196.105

set :branch, 'master'
set :rails_env, 'production'

role :web, "18.216.232.239", user: 'zuluplus'
role :app, "18.216.232.239", user: 'zuluplus'
role :db , "18.216.232.239", user: 'zuluplus'
