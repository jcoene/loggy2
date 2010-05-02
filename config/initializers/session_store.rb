# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_loggy_session',
  :secret      => 'bdf72bdac1b04b15c27bfab944e38d52de31e1b0ed36fc5641f26be956a80bc6ff287c0c34b39650840b1d2aece8f14e1553d2174c59c5b48fa2db364f583382'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
