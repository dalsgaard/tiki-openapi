def get_bar(id:, q: nil)
  puts id, q
  [200, {}, ["Bar! #{id} #{q}"]]
end
