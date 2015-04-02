class Piece
  PAWN_DELTAS = [
    [1,  1],
    [1, -1]
  ]

  W_PAWN_DELTAS = [
    [-1, -1],
    [-1,  1]
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
      deltas = W_PAWN_DELTAS if @color == :w
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
    end

    true
  end

  def perform_jump(dest)
    jumped_piece_pos = []
    move_diffs.each do |diff|
      jumped_pos = [pos.first + diff.first, pos.last + diff.last]
      behind_pos = [jumped_pos.first + diff.first, jumped_pos.last + diff.last]
      next if @board[jumped_pos].nil?
      if (@board[jumped_pos].color != self.color) && (@board[behind_pos].nil?)
         jumped_piece_pos = jumped_pos
         break if behind_pos == dest
      end
    end

    if jumped_piece_pos.empty?
      return false
    else
      @board[pos] = nil
      @board[jumped_piece_pos].pos = nil
      @board[jumped_piece_pos] = nil
      @board[dest] = self
      @pos = dest
    end

    true
  end
end
