def create_operation(spec, operations)
  puts spec
  id = spec["operationId"].to_sym
  op = operations.respond_to?(id) && operations.method(id)
  if op
    lambda do |env|
      params = env["router.params"]
      op.call(**params)
    end
  else
    puts "Method not implementet: '#{id}'"
    lambda do |_|
      [500, { "Content-Type" => "text/plain" }, ["Not implemented!"]]
    end
  end
end
