require_relative 'piece.rb'
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
end
