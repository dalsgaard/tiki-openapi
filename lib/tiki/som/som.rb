module SOM
  VERBS = %i[get put post delete patch].freeze

  class Server
    attr_reader :url

    def initialize(spec)
      @url = spec['url']
    end
  end

  class Operation
    attr_reader :path, :verb, :id, :parameters

    def initialize(path, verb, spec, path_params)
      @path = path
      @verb = verb
      @id = spec['operationId'].to_sym
      params = spec['parameters']&.map do |param|
        SOM::Parameter.new param
      end || []
      @parameters = params + path_params
    end
  end

  class Parameter
    attr_reader :name, :in

    def initialize(spec)
      @name = spec['name'].to_sym
      @in = spec['in'].to_sym
    end
  end
end

class SpecObjectModel
  attr_reader :operations, :servers

  def initialize(spec)
    create_operations spec['paths']
    create_servers spec['servers']
  end

  private

  def create_servers(spec)
    @servers = spec&.map do |server|
      SOM::Server.new server
    end
  end

  def create_operations(spec)
    @operations = []
    spec.each_pair do |path, path_item|
      params = path_item['parameters']&.map do |param|
        SOM::Parameter.new param
      end || []
      SOM::VERBS.each do |verb|
        op = path_item[verb.to_s]
        @operations << SOM::Operation.new(path, verb, op, params) if op
      end
    end
  end
end
