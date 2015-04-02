require_relative 'piece.rb'
require 'colorize'
class Board

  def self.checkered?(row, col)
    (row.even? && col.even?) || (row.odd? && col.odd?)
  end

  def self.empty
      Array.new(8) { Array.new(8) }
  end

  attr_reader :grid

  def initialize(grid = self.class.empty)
    @grid = grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def lose?(color)
    pieces = []
    grid.each do |row|
      return false if row.compact.any? { |tile| tile.color == color }
    end

    true
  end

  def valid_pos?(pos)
    pos.first.between?(0, 7) && pos.last.between?(0, 7)
  end

  def render
    puts "  A B C D E F G H"
    @grid.each_with_index do |row, r_idx|
      line = ""
      row_num = r_idx + 1
      row.each_with_index do |tile, c_idx|
        if tile.nil?
          if self.class.checkered?(r_idx, c_idx)
            line += "  ".on_light_white
          else
            line += "  ".on_light_black
          end
        else
          if self.class.checkered?(r_idx, c_idx)
            line += (" " + tile.symbol[tile.color]).on_light_white
          else
            line += (" " + tile.symbol[tile.color]).on_light_black
          end
        end
      end
      puts "#{row_num} " + line
    end

  end


end
