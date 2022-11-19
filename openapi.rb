require './lib/spec'

indir, outdir, ext = ARGV
outdir ||= indir
ext ||= 'oas.rb'

Dir.glob File.join(indir, "*.#{ext}") do |infile|
  outfile = File.join outdir, "#{File.basename(infile, '.rb')}.json"
  puts infile, outfile
  spec = Spec.new
  spec.instance_eval File.read(infile)
  json = JSON.pretty_generate spec.to_spec
  File.write outfile, json
end
