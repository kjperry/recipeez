#!/usr/bin/ruby

require 'json'

filename = ARGV[0]
if filename.nil?
  puts "Please specify a file to convert"
  exit
end

markdown = File.open(filename).read

@recipe = {}
@steps = []
@ingredients = []

markdown.each_line do |line|
  case line
  when /^\# /
    @recipe[:title] = line[2..-1]
  when /^\*/
    if line.start_with?("* ")
      array = line.rpartition(/\d/)
      quantity = array[0..array.length-2].join + " " + array.last.split(" ")[0]
      quantity = quantity[2..-1]
      item = line.sub(quantity, "").strip[3..-1]
      @ingredients << {item => quantity}
    else
      @ingredients << {line[2..-1] => ""}
    end
  when /^1\./
    @steps << line[3..-1].strip
  end
end

@recipe[:ingredients] = @ingredients
@recipe[:steps] = @steps

puts @recipe.to_json
