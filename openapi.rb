require './lib/tiki'

indir, outdir, ext = ARGV
outdir ||= indir
ext ||= 'oas.rb'

tiki indir, outdir, ext
