# Load data from file into a hash
options_data = {}
File.open("options.txt").each do |line|
  option, *ratings = line.chomp.split(",")
  options_data[option] = ratings.map(&:to_i)
end

# Method to calculate similarity between two options
def calculate_similarity(option1, option2, options_data)
  ratings1 = options_data[option1]
  ratings2 = options_data[option2]
  sum_of_squares = ratings1.zip(ratings2).sum { |a, b| (a - b) ** 2 }
  1 / (1 + Math.sqrt(sum_of_squares))
end

# Get user inputs
user_inputs = []
5.times do |i|
  print "Enter input #{i + 1}: "
  user_input = gets.chomp
  user_inputs << user_input
end

# Calculate similarities between user inputs and all other options
similarities = Hash.new(0)
user_inputs.each do |input|
  options_data.keys.each do |option|
    next if user_inputs.include?(option) # Skip inputs already provided by the user
    similarities[option] += calculate_similarity(input, option, options_data)
  end
end

# Sort options by similarity and output the top 5
top_5_similar_options = similarities.sort_by { |_, similarity| -similarity }.first(5).map(&:first)

# Output the top 5 similar options
puts "Top 5 similar options:"
top_5_similar_options.each_with_index do |option, index|
  puts "#{index + 1}. #{option}"
end
