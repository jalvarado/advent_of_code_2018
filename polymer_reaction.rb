module PolymerReaction
  def self.shortest_polymer(polymer_string)
    chars = polymer_string.chars.map(&:downcase).uniq

    chars.map do |wildcard|
      chain_reaction(polymer_string.gsub(/[#{wildcard}#{wildcard.upcase}]/, ''))
    end.min
  end
  def self.chain_reaction(polymer_string)
      new_polymer = react(polymer_string)
      return new_polymer.size if polymer_string == new_polymer
      chain_reaction(new_polymer)
  end

  def self.react(polymer_string)
    units = polymer_string.chars

    reacted_poloymer = []

    while units.size > 0
      l = units.shift
      r = units[0]
      if l && r && (l != r && l.downcase == r.downcase)
        # Remove r
        units.delete_at(0)
      else
        reacted_poloymer.push(l)
      end
    end

    reacted_poloymer.join

  end

end

if __FILE__ == $0
  input_filename = ARGV[0]
  puts "Reading data from #{input_filename}"

  polymer = File.read(input_filename).chomp

  puts "New Polymer: #{PolymerReaction.chain_reaction(polymer).inspect}"

  puts "Shortest Polymer String: #{PolymerReaction.shortest_polymer(polymer)}"

end
