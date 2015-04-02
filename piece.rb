class Piece
  PAWN_DELTAS = [
    [1,  1],
    [1, -1]
  ]

  KING_DELTAS = [
    [ 1,  1],
    [ 1, -1],
    [-1,  1],
    [-1, -1]
  ]

  attr_accessor :pos
  attr_reader :color

  def is_king?
    @is_king
  end
  def symbol
    if is_king?
      { :w => '☆', :b => '★'}
    else
      { :w => '◎', :b => '◉'}
    end
  end

  def initialize(board, color, pos)
    @color = color
    @is_king = false
    @pos = pos
    @board = board
    place_on_board
  end

  def place_on_board
    @board[pos] = self
  end

  def move_diffs
    deltas = nil
    available_dirs = []
    if @is_king
      deltas = KING_DELTAS
    else
      deltas = PAWN_DELTAS
      deltas = -deltas if @color == :w
    end

    deltas.each do |move|
      new_pos = [pos.first + move.first, pos.last + move.last]
      if new_pos.first.between?(0, 7) && new_pos.last.between?(0, 7)
        available_dirs << move
      end
    end

    available_dirs
  end

  def perform_slide(dest)
    move_to_arr = []
    move_diffs.each do |diff|
      new_pos = [pos.first + diff.first, pos.last + diff.last]
      move_to_arr << new_pos if @board[new_pos].nil?
    end
    if move_to_arr.empty? || !move_to_arr.include?(dest)
      return false
    else
      @board[pos] = nil
      @board[dest] = self
      @pos = dest
      true
    end

  end

  def perform_jump(dest)
    move_diffs.each do |diff|

    end

  end
end
