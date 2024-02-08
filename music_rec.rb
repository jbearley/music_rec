# Load the data from the file into a hash
data = {}
File.open("options.txt").each do |line|
  option, *ratings = line.chomp.split(",")
  data[option] = ratings.map(&:to_i)
end

# Method to calculate similarity between two options
def similarity(option1, option2, data)
  ratings1 = data[option1]
  ratings2 = data[option2]
  sum_of_squares = ratings1.zip(ratings2).map { |a, b| (a - b) ** 2 }.sum
  1 / (1 + Math.sqrt(sum_of_squares))
end

# Get inputs from the user
inputs = []
5.times do |i|
  print "Enter input #{i + 1}: "
  input = gets.chomp
  inputs << input
end

# Calculate similarities between inputs and all other options
similarities = {}
inputs.each do |input|
  data.keys.each do |option|
    next if inputs.include?(option) # Skip inputs already provided by the user
    similarities[option] ||= 0
    similarities[option] += similarity(input, option, data)
  end
end

# Sort options by similarity and output the top 5
top_5_similar_options = similarities.sort_by { |_, similarity| -similarity }.first(5).map(&:first)

# Output the top 5 similar options
puts "Top 5 similar options:"
top_5_similar_options.each_with_index do |option, index|
  puts "#{index + 1}. #{option}"
end