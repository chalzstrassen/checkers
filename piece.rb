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

  def move_diffs
    deltas = nil
    available_dirs = []

    if @is_king
      deltas = KING_DELTAS
    else
      deltas = @color == :w ? W_PAWN_DELTAS : PAWN_DELTAS
    end

    deltas.each do |move|
      new_pos = [pos.first + move.first, pos.last + move.last]
      if @board.valid_pos?(new_pos)
        available_dirs << move
      end
    end

    available_dirs
  end

  def perform_slide(dest)
    move_diffs.each do |diff|
      new_pos = [pos.first + diff.first, pos.last + diff.last]
      if @board[new_pos].nil? && new_pos == dest
        execute_slide(dest)
        return true
      end
    end

    false
  end

  def perform_jump(dest)
    move_diffs.each do |diff|
      jumped_pos = [pos.first + diff.first, pos.last + diff.last]
      behind_pos = [jumped_pos.first + diff.first, jumped_pos.last + diff.last]
      next if @board[jumped_pos].nil?
      if can_jump?(jumped_pos, behind_pos) && behind_pos == dest
         execute_jump(jumped_pos, dest)
         return true
      end
    end

    false
  end

  def perform_moves!(move_sequence)
    raise InvalidMoveError, "Move sequence is empty." if move_sequence.empty?

    if move_sequence.count == 1
      move_to = move_sequence.first
      if perform_slide(move_to)
        return
      elsif perform_jump(move_to)
        return
      else
        raise InvalidMoveError, "The move is invalid."
      end
    else
      chain_moves(move_sequence)
    end
  end

  def valid_move_seq?(move_sequence)
      grid_dup = Array.new(8) { Array.new(8) }
      @board.grid.each_with_index do |row, r_idx|
        row.each_with_index do |tile, c_idx|
          grid_dup[r_idx][c_idx] = tile
        end
      end

      piece_dup = self.class.new(Board.new(grid_dup), color, pos)
      begin
        piece_dup.perform_moves!(move_sequence)
      rescue InvalidMoveError => e
        puts "Error: #{e.message}"
        return false
      else
        true
      end

  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError, "Try another sequence."
    end

    @is_king = true if maybe_promote
  end

  private

    def place_on_board
      @board[pos] = self
    end

    def can_jump?(jumped_pos, behind_pos)
      (@board[jumped_pos].color != self.color) && (@board[behind_pos].nil?)
    end

    def execute_jump(jumped_pos, dest)
      @board[pos] = nil
      @board[jumped_pos].pos = nil
      @board[jumped_pos] = nil
      @board[dest] = self
      @pos = dest
    end

    def execute_slide(dest)
      @board[pos] = nil
      @board[dest] = self
      @pos = dest
    end

    def chain_moves(move_sequence)
      move_sequence.each do |move|
        if perform_jump(move)
          next
        else
          raise InvalidMoveError, "A move in the sequence is invalid."
        end
      end
    end

    def maybe_promote
      if is_king?
        return false
      else
        if pos.first == 0 && color == :w
          true
        elsif pos.first == 7 && color == :b
          true
        else
          false
        end
      end
    end

end

class InvalidMoveError < StandardError

end
