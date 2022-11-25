require_relative './tiki/spec'
require_relative './tiki/list-helpers'

using ListHelpers

def tiki(indir, outdir, ext)
  Dir.glob File.join(indir, "*.#{ext}") do |infile|
    outfile = File.join outdir, "#{File.basename(infile, '.rb')}.json"
    puts "#{infile} -> #{outfile}"
    spec = Spec.new
    spec.instance_eval File.read(infile)
    json = JSON.pretty_generate spec.to_spec
    File.write outfile, json
  end
end
