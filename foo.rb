class Foo
  def in(_in)
    puts _in
  end
end

foo = Foo.new
foo.in :query
