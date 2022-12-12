require 'json'
require_relative './som/som'
require_relative './client/client'

class TikiClient < Client
  def initialize(_spec = nil, spec: nil, som: nil, file: nil)
    spec ||= _spec
    if som
      super som
    elsif spec
      som = SpecObjectModel.new spec
      super som
    elsif file
      spec = JSON.parse File.read(file)
      som = SpecObjectModel.new spec
      super som
    end
  end
end
