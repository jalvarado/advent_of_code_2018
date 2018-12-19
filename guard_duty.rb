module GuardDuty
  Guard = Struct.new("Guard", :id, :total_sleep_time, :minutes)

  def self.strategy_two(log_entries)
    guards = parse_log(log_entries)

    guard_id, _freq, minute = guards.values
      .map {|guard| [guard.id, guard.minutes.each_with_index.max_by(&:first)].flatten}
      .max_by {|id, freq, minute| freq}

    guard_id * minute
  end

  def self.strategy_one(log_entries)
    guards = parse_log(log_entries)
    sleepiest_guard = guards.values.max_by(&:total_sleep_time)
    most_common_sleep_minute = sleepiest_guard.minutes.each_with_index.max_by(&:first).last
    sleepiest_guard.id * most_common_sleep_minute
  end

  def self.parse_log(log_entries)
    guards = {}

    current_guard = nil
    falls_asleep_at = nil
    wakes_at = nil
    log_entries.each do |log_line|
      if log_line =~ /Guard \#(\d+) begins shift$/
        id = $1.to_i
        puts "Guard #{id} begins shift"
        current_guard = guards.fetch(id) { guards[id] = Guard.new(id, 0, [0] * 60) }
      elsif  / 00:(?<minute>\d+)\] falls asleep$/ =~ log_line
        falls_asleep_at = minute.to_i
        puts "Guard #{current_guard.id} falls asleep at #{falls_asleep_at}"
      elsif / 00:(?<minute>\d+)\] wakes up$/ =~ log_line
        wakes_at = minute.to_i

        minutes_slept = (wakes_at - falls_asleep_at)
        current_guard.total_sleep_time += minutes_slept
        (falls_asleep_at...wakes_at).each {|min| current_guard.minutes[min] += 1}

        puts "Guard #{current_guard.id} wakes up at #{wakes_at}.  Slept for #{minutes_slept}"
      end
    end
    guards
  end
end

if __FILE__ == $0
  input_filename = ARGV[0]
  puts "Reading data from #{input_filename}"

  guard_log = File.readlines(input_filename)
  puts GuardDuty.strategy_one(guard_log.sort)

  guard_log = File.readlines(input_filename)
  puts GuardDuty.strategy_two(guard_log.sort)
end
