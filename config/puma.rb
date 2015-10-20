threads 2,10
workers 3

bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 9393)}"

preload_app!
