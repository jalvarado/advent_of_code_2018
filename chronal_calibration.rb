module ChronalCalibration
  def self.calculate_frequency(frequency_changes)
    frequency_changes.inject(0) {|memo, frequency_change|
      memo + frequency_change.to_i
    }
  end

  def self.calculate_first_repeat(frequency_changes, current_frequency=0, hit_frequencies=Hash.new {|h,k| h[k]=1})
    frequency_changes.each do |frequency_change|
      if hit_frequencies.has_key?(current_frequency)
        return current_frequency
      else
        hit_frequencies[current_frequency]
        current_frequency = current_frequency + frequency_change.to_i
      end
    end

    puts "Reached the end of the frequency list"
    calculate_first_repeat(frequency_changes, current_frequency, hit_frequencies)
  end
end

if __FILE__ == $0
  input_filename = ARGV[0]
  puts "Reading data from #{input_filename}"

  frequency_changes = File.readlines(input_filename)
  puts ChronalCalibration.calculate_frequency(frequency_changes)

  puts "First Repeat"
  puts ChronalCalibration.calculate_first_repeat(frequency_changes, 0)
end
