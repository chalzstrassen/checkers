require_relative 'piece.rb'
require 'colorize'
class Board

  def self.default
      Array.new(8) { Array.new(8) }
  end

  def initialize(grid = self.class.default)
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

  def render
    puts "  A B C D E F G H"
    @grid.each_with_index do |row, r_idx|
      line = ""
      row_num = r_idx + 1
      row.each_with_index do |tile, c_idx|
        if tile.nil?
          if (r_idx.even? && c_idx.even?) || (r_idx.odd? && c_idx.odd?)
            line += "  ".on_light_white
          else
            line += "  ".on_light_black
          end
        else
          if (r_idx.even? && c_idx.even?) || (r_idx.odd? && c_idx.odd?)
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
