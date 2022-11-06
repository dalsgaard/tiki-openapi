require './lib/spec'

infile, outfile = ARGV
puts infile, outfile

if infile && outfile
  spec = Spec.new

  spec.instance_eval File.read(infile)

  json = JSON.pretty_generate spec.to_spec

  File.write outfile, json
end
