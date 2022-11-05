require "./lib/spec.rb"

spec = Spec.new

spec.instance_eval File.read("./examples/demo-spec.rb")

json = JSON.pretty_generate spec.to_spec

File.write "out.spec.json", json
