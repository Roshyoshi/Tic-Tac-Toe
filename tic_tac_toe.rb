# frozen_string_literal: true

# Game class for game board of tic tac toe, players and simulation of turns
class Game
  def initialize
    puts 'Welcome to Tic Tac Toe'
    @size = 3
    @game_board = Board.new(@size)
    @players = [Player.new('O'), Player.new('X')]
  end

  def turn
    @players.each do |player|
      print_board
      player.move(@game_board)
      current_result = Player.get_winner(@game_board)
      return current_result unless current_result.nil?
    end
    nil
  end
  def print_board
    count = 1
    #print "|"
    (@size * 4 + 1).times {print '='}
    @game_board.board.each do |row|
      print "\n|"
      row.each do |square| 
        print square.nil? ? " #{count} |" : " #{square} |"
        count += 1
      end
      print "\n|"
      (@size - 1).times {print "---+"}
      print "---|"
    end
    print "\n"
    (@size *4 + 1).times {print '='}
    puts "\n"
  end
end

# Player class for representing players who make moves. Also decides winner of game.
class Player
  attr_reader :role

  def initialize(role)
    @role = role
  end

  def move(board)
    puts "Player #{@role}'s move! Enter the number of the square you would like to move to."
    move = [0, 0]
    loop do
      print "Number in range 1 to #{ board.size**2 }: "
      input = gets.chomp.to_i
      next unless (1..board.size**2).include?(input)
      move = [input % board.size - 1, (input - 0.01).to_i/board.size]
      unless board.board[move[1]][move[0]].nil?
        print "That spot is taken!"
        next
      end
      board.board[move[1]][move[0]] = @role
      break
    end
    puts ''
  end

  def self.get_winner(board)
    [board.board, board.flip.board].each do |board|
      board.each do |row|
        return row[0] if row.uniq.count == 1 && !row.uniq[0].nil?
      end
    end

    [board, board.reverse].each do |arr|
      diagonal_arr = arr.diagonal_arr_calc
      return diagonal_arr[0] if diagonal_arr.uniq.count == 1 && !diagonal_arr.uniq[0].nil?
    end
    nil
  end
end

# Board class for representing game board. Also helps with decision of winner.
class Board
  attr_reader :board, :size

  def initialize(size, board = nil)
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
    Board.new(@size, @board.map(&:reverse))
  end

  def flip
    Board.new(@size, @board.transpose.map(&:reverse))
  end
end

game = Game.new
result = nil
result = game.turn while result.nil?

puts "Player #{result} wins!\n"

game.print_board
