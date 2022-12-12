require_relative './tiki/client'

infile = 'demos/serve.oas.json'

client = TikiClient.new file: infile

puts client.get_bar(id: 'abc123', q: 'wauw')
