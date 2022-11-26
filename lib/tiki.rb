require 'optimist'
require_relative './tiki/spec'
require_relative './tiki/list-helpers'

using ListHelpers

def tiki
  opts = Optimist.options do
    opt :indir, 'Input directory', default: '.'
    opt :outdir, 'Output directory', type: :string
    opt :ext, 'Extension of the input files', default: 'oas.rb'
  end

  indir = opts[:indir]
  outdir = opts[:outdir] || indir
  ext = opts[:ext]

  infiles = Dir.glob File.join(indir, "*.#{ext}")
  puts "Found #{infiles.size} input #{infiles.size == 1 ? 'file' : 'files'}"
  infiles.each do |infile|
    outfile = File.join outdir, "#{File.basename(infile, '.rb')}.json"
    puts "#{infile} -> #{outfile}"
    spec = Spec.new
    spec.instance_eval File.read(infile)
    json = JSON.pretty_generate spec.to_spec
    File.write outfile, json
  end
end
