# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_store, key: 'plavest_session', servers: ["redis://127.0.0.1:6379/1/pl_ss"]
