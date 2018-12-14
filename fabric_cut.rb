require 'set'

module FabricCut
  extend self

  class Claim
    attr_reader :x, :y, :width, :height, :claim

    def self.from_string(claim_string)
      claim_regex = /^#(?<claim>\d+)\s@\s(?<x>\d+),(?<y>\d+):\s(?<width>\d+)x(?<height>\d+)$/
      m = claim_regex.match(claim_string)
      puts "invalid claim string: #{claim_string}" if m.nil?
      self.new(m[:claim], m[:x].to_i, m[:y].to_i, m[:width].to_i, m[:height].to_i)
    end

    def initialize(claim, x, y, width, height)
      @claim = claim
      @x = x
      @y = y
      @width = width
      @height = height
    end

    def points
      @points ||= (x..x+width-1).to_a.product((y..y+height-1).to_a)
    end
  end

  def overlapping_sections(squares)
    overlap_set = Set.new
    claims = squares.map {|claim| Claim.from_string(claim) }
    claims.combination(2).each do |square1, square2|
      overlaps = overlapping_points(square1, square2)
      overlap_set = overlap_set.merge(overlaps) if overlaps && !overlaps.count.zero?
    end
    overlap_set.count
  end

  def overlapping_points(square1, square2)
    Set.new(square1.points & square2.points)
  end

  def find_claim_with_no_overlaps(claim_strings)
    claims = claim_strings.map {|claim_string| Claim.from_string(claim_string)}

    claims.map {|claim| [claim,claims - [claim]]}
      .select {|claim, other_claims| 
        other_claims.all? {|claim2| overlapping_points(claim, claim2).empty? }
      }.map(&:first)
    
  end
end

if __FILE__ == $0
  input_filename = ARGV[0]
  puts "Reading data from #{input_filename}"

  squares = File.readlines(input_filename).map(&:chomp)
  #puts FabricCut.overlapping_sections(squares)

  puts FabricCut.find_claim_with_no_overlaps(squares).inspect
end