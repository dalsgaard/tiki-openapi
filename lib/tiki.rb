require 'optimist'
require_relative './tiki-spec'
require_relative './tiki-serve'
require_relative './tiki/client'
require_relative './tiki-types'

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
  when 'types'
    tiki_types
  else
    puts "Unknown sub-command '#{cmd}'"
  end
end
