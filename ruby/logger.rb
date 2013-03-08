#!/usr/bin/env ruby
require 'logger'

log = Logger.new( 'log.txt', 'daily' )

log.debug "Once the log becomes at least one"
log.debug "day old, it will be renamed and a"
log.debug "new log.txt file will be created."
