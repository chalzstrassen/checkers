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

  attr_accessor :pos, :is_king

  def initialize(board, color, pos)
    @board = board
    @color = color
    @is_king = false
    @pos = pos
  end

  def move_diffs
    deltas = nil
    available_moves = []
    if @is_king
      deltas = KING_DELTAS
    else
      deltas = PAWN_DELTAS
      deltas = -deltas if @color == :w
    end

    deltas.each do |move|
      new_pos = [pos.first + move.first, pos.last + move.last]
      if new_pos.first.between?(0, 7) && new_pos.last.between?(0, 7)
        available_moves << new_pos
      end
    end

    available_moves
  end

  def perform_slide(dest)
    return false unless move_diffs.include?(dest)
    @pos = dest

    true
  end
end
