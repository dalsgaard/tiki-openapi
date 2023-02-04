require 'json'
require 'optimist'
require_relative './tiki/spec/spec'
require_relative './tiki/spec/list-helpers'

using ListHelpers

def tiki_spec
  opts = Optimist.options do
    opt :indir, 'Input directory', type: :string
    opt :outdir, 'Output directory', type: :string
    opt :ext, 'Extension of the input files', default: 'oas.rb'
  end

  indir = opts[:indir] || '.'
  outdir = opts[:outdir]
  ext = opts[:ext]

  infiles = ARGV
  infiles = Dir.glob File.join(indir, "*.#{ext}") if infiles.empty?
  files = infiles.map do |infile|
    d = outdir || File.dirname(infile)
    outfile = File.join d, "#{File.basename(infile, '.rb')}.json"
    [infile, outfile]
  end

  puts "Found #{files.size} input #{files.size == 1 ? 'file' : 'files'}"
  files.each do |infile, outfile|
    puts "#{infile} -> #{outfile}"
    spec = Spec.new
    spec.instance_eval File.read(infile)
    json = JSON.pretty_generate spec.to_spec
    File.write outfile, json
  end
end
