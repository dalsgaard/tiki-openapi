require 'hanami/router'

app = Hanami::Router.new

def execute(name, env)
  env.each_pair do |key, _value|
    puts key
  end
  [200, {}, ["Hellooo from #{name}"]]
end

%i[foo bar baz].each do |name|
  app.get "/#{name}/:#{name}", to: ->(env) { execute name, env }
end

run app
