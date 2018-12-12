module InventoryManagement
  def self.check_sum(bar_codes)
    pairs, triples = bar_codes.inject([0,0]) do |count_array, bar_code|
      counts = bar_code.split('').group_by(&:itself).map {|k,v| [k, v.count]}.to_h

      [
        count_array[0] + (counts.any? {|_, c| c == 2} ? 1 : 0),
        count_array[1] + (counts.any? {|_, c| c == 3} ? 1 : 0)
      ]
    end

    pairs * triples
  end

  def self.find_prototype_boxes(bar_codes)
    bar_codes.combination(2) do |bar_code1, bar_code2|
      diff = bar_code1.split('')
        .zip(bar_code2.split(''))
        .map {|a,b| a == b ? a : nil}
      if diff.count(nil) == 1
        return diff.join
      end
    end
  end

end


if __FILE__ == $0
  input_filename = ARGV[0]
  puts "Reading data from #{input_filename}"

  bar_codes = File.readlines(input_filename)
  puts InventoryManagement.check_sum(bar_codes)

  puts "box code: "
  puts InventoryManagement.find_prototype_boxes(bar_codes)
end
