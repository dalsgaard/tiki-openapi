def default(*urls, **named)
  puts urls, named
end

default 'baz', 'foo-bar': 'Foo Bar'
