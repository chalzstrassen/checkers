require_relative 'board'
require 'byebug'

class Game
  COLUMN = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }
  attr_reader :board

  def initialize
    @board = Board.new
    @players = { :w => Player.new(:w), :b => Player.new(:b) }
    @turn = :b
    fill_board
  end

  def play
    color_hash = { :b => "Black", :w => "White" }

    until @board.lose?(@turn)
      @board.render
      puts "#{color_hash[@turn]}'s turn"
      puts "Select a piece. E.g 'A7'."
      move_piece = select_piece
      begin
        puts "Give a move sequence separated by spaces. E.g 'A1 C3 E5'."
        seq_arr = move_sequences
        move_piece.perform_moves(seq_arr)
      rescue StandardError
        puts "Try again!"
        retry
      end
      @turn = (@turn == :b) ? :w : :b
    end
    puts "#{color_hash[@turn]} loses!"
  end


  private
    def move_sequences
      seq_arr = []
      input = gets.chomp.downcase
      input.split(" ").each do |move|
        seq_arr << parse_entry(move)
      end

      seq_arr
    end

    def parse_entry(input)
      [Integer(input[1]) - 1, COLUMN[input[0]]]
    end

    def select_piece
        input = gets.chomp.downcase
        #byebug
        pos = parse_entry(input)
        raise "Invalid selection" if @board[pos].nil? || @board[pos].color != @turn
      rescue
        puts "Try another selection"
        retry
      else
        @board[pos]
    end

    def fill_board
      3.times do |row|
        8.times do |col|
          if @board.class.checkered?(row, col)
            Piece.new(@board, :b, [row, col])
          end
        end
      end

      7.downto(5).each do |row|
        8.times do |col|
          if @board.class.checkered?(row, col)
            Piece.new(@board, :w, [row, col])
          end
        end
      end

    end
end


class Player
  def initialize(color)
    @color = color
  end


end
