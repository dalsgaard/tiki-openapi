require 'optimist'

opts = Optimist.options do
  opt :corn, 'We have corn'
  opt :cheese, 'Name of the cheese', type: :string
  opt :chickens, 'Number of chickens', default: 4
end

puts opts
puts ARGV
