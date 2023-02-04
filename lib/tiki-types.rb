require 'optimist'

require_relative './tiki/som/som'

def tiki_types
  opts = Optimist.options do
    opt :verbose, 'Verbose output'
    opt :server, 'Create server types', default: false
    opt :client, 'Create client types', default: false
    opt :ts, 'Create TypeScript types', default: false
  end

  spec_file = ARGV[0]
  if spec_file
    spec = JSON.parse File.read(spec_file)
    som = SpecObjectModel.new spec

    if opts[:ts] && (opts[:client])
      require_relative './tiki/types/typescript/client/create'
      puts Types::TypeScript::Client.create som
    end
  else
    puts 'No input file'
  end
end
