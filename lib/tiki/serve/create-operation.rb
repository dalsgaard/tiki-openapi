def create_operation(spec, operations)
  puts spec
  id = spec['operationId'].to_sym
  op = operations.method(id)
  lambda { |env|
    params = env['router.params']
    op.call(**params)
  }
end
