class Symbol
  def |(other)
    puts "#{self} | #{other}"
  end

  def &(other)
    puts "#{self} & #{other}"
  end
end

:foo | :bar
:bar & :baz
