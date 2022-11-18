# frozen_string_literal: true

# Game class for game board of tic tac toe, players and simulation of turns
class Game
  def initialize
    @game_board = Array.new(3) { Array.new(3, :blank) }
    @players = [Player.new('O'), Player.new('X')]
  end

  def turn
    print_board
    @players.each do |player|
      move = player.move
      @game_board[move[0], move[1]] = player.role
      current_result = Player.get_winner(game_board)
      return current_result unless current_result.nil?
    end
  end

  private

  def print_board
    @game_board.each do |row|
      row.each { |square| print square }
      puts ''
    end
  end
end

module BoardTools
  def diagonal_arr_calc(board)
    element = 0
    board.each_with_object([]) do |row, diagonal_arr|
      diagonal_arr << row[element]
      element += 1
    end
  end
end

# Player class for representing players who make moves. Also decides winner of game.
class Player
  import BoardTools
  attr_reader :role

  def initialize(role)
    @role = role
  end

  def self.get_winner(game_board)
    [game_board, game_board.transpose.map(&:reverse)].each do |board|
      board.each do |row|
        return row[0] if row.uniq.count == 1
      end
    end
    [diagonal_arr_calc(game_board), diagonal_arr_calc(game_board.map(&:reverse))].each do |diagonal_arr|
      return diagonal_arr[0] if diagonal_arr.uniq.count == 1
    end
  end
end
