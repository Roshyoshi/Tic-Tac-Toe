# frozen_string_literal: true

# Game class for game board of tic tac toe, players and simulation of turns
class Game
  def initialize
    puts "Welcome to Tic Tac Toe!"
    @game_board = Board.new(3)
    @players = [Player.new('O'), Player.new('X')]
  end

  def turn
    @players.each do |player|
      print_board
      player.move(@game_board.board)
      current_result = Player.get_winner(@game_board)
      return current_result unless current_result.nil?
    end
    return nil
  end

  def print_board
    @game_board.board.each do |row|
      row.each { |square| print square.nil? ? "#" : square}
      puts ''
    end
    puts ''
  end
end

# Player class for representing players who make moves. Also decides winner of game.
class Player
  attr_reader :role

  def initialize(role)
    @role = role
  end

  def move(board)
    puts "Player #{@role}'s move! Enter two numbers between 1 and 3."
    move = [0, 0]
    while true
      print 'The format is "x y" : '
      move = gets.chomp.split.map(&:to_i)
      next if move.nil?
      next if move.count != 2
      next if move.none? { |coord| coord in 1..3 }
      move = move.map { |num| num - 1 }
      move[1] = 2 - move[1]
      next unless board[move[1]][move[0]].nil?
      board[ move[1]][move[0]] = @role
      break
    end
    puts ''
  end

  def self.get_winner(board)
    [board.board, board.flip.board].each do |board|
      board.each do |row|
        return row[0] if row.uniq.count == 1 && row.uniq[0] != nil
      end
    end
      
    [board, board.reverse].each do |arr|
        diagonal_arr = arr.diagonal_arr_calc
        return diagonal_arr[0] if diagonal_arr.uniq.count == 1 && diagonal_arr.uniq[0] != nil
    end
    return nil
  end
end

# Board class for representing game board. Also helps with decision of winner.
class Board
  attr_reader :board

  def initialize(size, board=nil)
    @size = size
    @board = board.nil? ? Array.new(size) { Array.new(size, nil) } : board
  end

  def diagonal_arr_calc
    element = 0
    @board.each_with_object([]) do |row, diagonal_arr|
      diagonal_arr << row[element]
      element += 1
    end
  end
  def reverse
    return Board.new(@size, @board.map(&:reverse))
  end
  def flip
    return Board.new(@size, @board.transpose.map(&:reverse))
  end
end

game = Game.new
result = nil
result = game.turn while result.nil?

puts "Player #{result} wins!\n"

game.print_board
