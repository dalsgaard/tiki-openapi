require 'optimist'
require_relative './tiki-spec'

SUB_COMMANDS = %w[spec serve].freeze

def tiki
  Optimist.options do
    banner 'Tiki OpenAPI Utilities'
    stop_on SUB_COMMANDS
  end

  cmd = ARGV.shift
  case cmd
  when 'spec'
    tiki_spec
  when 'serve'
    puts 'Serve'
  else
    puts "Unknown sub-command '#{cmd}'"
  end
end
