require './other-thing'
FileUtils.mkdir_p('log')

after_fork do |server,worker|
  ::Wavii::OtherThing.after_fork!
end

worker_processes 3
listen 4568, :tcp_nodelay => true, :backlog => 16
timeout 60
pid "log/unicorn.pid"

if ENV['RACK_ENV'] == 'production'
  puts "We are daemonizing and writing to log file 'log/crawler.log'"
  require 'fileutils'
  logger Logger.new('log/crawler.log')
end

