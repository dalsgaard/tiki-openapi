require 'hanami/router'
require_relative './create-operation'

def create_app(spec, operations, verbose: false)
  puts verbose
  paths = spec['paths']

  Hanami::Router.new do
    paths.each_pair do |path, verbs|
      p = path.gsub(%r{\{([^/]+)\}}, ':\1')
      get_op = verbs['get']
      get p, to: create_operation(get_op, operations) if get_op
      post_op = verbs['post']
      post p, to: create_operation(post_op, operations) if post_op
      put_op = verbs['put']
      put p, to: create_operation(put_op, operations) if put_op
      patch_op = verbs['patch']
      patch p, to: create_operation(patch_op, operations) if patch_op
      delete_op = verbs['delete']
      delete p, to: create_operation(delete_op, operations) if delete_op
    end
  end
end
