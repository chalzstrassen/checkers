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
  def initialize(color)
    @color = color
    @is_king = false
    
  end
end
