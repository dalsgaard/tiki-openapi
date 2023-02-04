require 'optimist'
require 'rack'
require 'rack/handler/puma'
require 'addressable/uri'

require_relative './tiki/som/som'
require_relative './tiki/serve/create-app'

module Operations
end

def tiki_serve
  opts = Optimist.options do
    opt :verbose, 'Verbose output'
    opt :indir, 'Input directory', default: 'operations'
    opt :ext, 'Extension of the input files', default: '.rb'
    opt :port, 'Default port to run the server on', type: :integer
    opt :host, 'Default host to run the server on', type: :string
  end

  spec_file = ARGV[0]
  if spec_file
    verbose = opts[:verbose]
    indir = opts[:indir]
    ext = opts[:ext]
    port = opts[:port]
    host = opts[:host]

    infiles = Dir.glob File.join(indir, "*#{ext}")
    puts "Loading #{infiles.size} #{infiles.size == 1 ? 'file' : 'files'}"
    infiles.each do |infile|
      Operations.instance_eval File.read(infile)
    end

    spec = JSON.parse File.read(spec_file)
    som = SpecObjectModel.new spec
    server = som.servers&.first

    if host || port
      host ||= 'localhost'
      port ||= 8340
    elsif server
      uri = Addressable::URI.parse(server.url)
      host = uri.host
      port = uri.port
    else
      host = 'localhost'
      port = 8340
    end

    app = create_app spec, Operations, verbose: verbose
    Rack::Handler::Puma.run app, Port: port, Host: host
  else
    puts 'No input file'
  end
end
