require 'excon'
require 'addressable/template'

class Client
  def initialize(som)
    @url = som.servers&.first&.url
    @conn = Excon.new @url if @url
    create_operations som.operations
  end

  private

  def create_operations(operations)
    operations.each do |op|
      query_names = op.parameters.select(&->(p) { p.in == :query }).map(&:name)
      define_singleton_method(op.id) do |**params|
        template = Addressable::Template.new op.path
        path = template.expand(params).to_s
        query = params.select do |name, _|
          query_names.include? name
        end
        res = @conn.request method: op.verb, path: path, query: query
        res.body
      end
    end
  end
end
