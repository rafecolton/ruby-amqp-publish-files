#!/usr/bin/env ruby

require 'bunny'
require 'pry'
require 'securerandom'
require 'trollop'

def main
  if opts[:verbose]
    puts <<-EOF.gsub(/^\s+/, '')
    publishing to #{opts[:exchange]}
    at #{opts[:url]}
    using routing-key #{opts[:'routing-key']}
    ------------------------------
    EOF
  end

  begin
    conn.start
    channel = conn.create_channel
    exchange = channel.topic(
      opts.fetch(:exchange),
      exchange_options
    )
    STDIN.read.split("\n").each do |filename|
      File.open(filename, 'r') do |f|
        msg = f.read
        exchange.publish(msg, message_options)
        puts "#{Time.now} #{filename}" if opts[:verbose]
      end
    end
  ensure
    conn.stop
  end

end

def opts
  @opts ||= Trollop::options do
    opt :uri, 'Full AMQP uri', :short => 'u', :default => 'amqp://guest:guest@localhost:5672'
    opt :'routing-key', 'Publish message to this routing key', :short => '-r', :required => true, :type => :string
    opt :exchange, 'Publish message to this exchange', :short => '-e', :required => true, :type => :string
    opt :verbose, 'Verbose mode', :short => '-v', :default => false
  end
end

def exchange_options
  {
    :durable => true,
    :autodelete => false,
  }
end

def message_options
  {
    :content_type => 'application/json',
    :content_encoding => 'UTF-8',
    :message_id => uuid,
    :correlation_id => uuid,
    :routing_key => opts[:'routing-key'],
  }
end

def conn
  @conn ||= Bunny.new(opts.fetch(:uri))
end

def uuid
  SecureRandom.uuid
end

if $0 == __FILE__
  main
end

