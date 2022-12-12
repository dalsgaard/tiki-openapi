require 'optimist'
require_relative './tiki-spec'
require_relative './tiki-serve'

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
    tiki_serve
  else
    puts "Unknown sub-command '#{cmd}'"
  end
end
