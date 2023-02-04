module Types
  module TypeScript
    module Client
      def self.create(som)
        operations = som.operations.map { |op| create_operation op }
        operations.join "\n\n"
      end

      def self.create_operation(op)
        name = camel_case op.id.to_s
        "export type #{name} = () => Promise<void>"
      end
    end
  end
end

def camel_case(str)
  str.gsub(/_([a-z])/) { Regexp.last_match(1).upcase }
end

def pascal_case(str)
  camel_case(str).capitalize
end
