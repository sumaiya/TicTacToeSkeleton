class Game < ActiveRecord::Base
  # Saves the board in the database as an object, 
  # and allows you to retrieve as the same object
  serialize :board
  
  include GamesHelper
  include ActiveModel::Validations

  # This line tells Rails which attributes of the model are accessible, i.e., 
  # which attributes can be modified automatically by outside users 
  # (such as users submitting requests with web browsers).
  attr_accessible :board

  default_scope :order => 'id ASC'
  validates :board, :presence => true

  # Initializes the object with a board, made up of a two dimensional array of
  # nils. Eg
  #   board = [ [nil, nil, nil],
  #             [nil, nil, nil],
  #             [nil, nil, nil]  ]
  #
  # This is called when you use `Game.new` or `Game.create!`.
  # NOTE ActiveRecord::Base does not have a #create method.
  def initialize
    super
    self.board = Array.new(3).map{[nil, nil, nil]} 
  end

  # Updates the board based on player, row, and column
  #
  # @param player [String] either 'x' or 'o'
  # @param row [Integer] 0-2
  # @param column [Integer] 0-2
  # @return [Boolean] Save successful?
  # @return ArgumentError
  # 
  # use helpers/games_helper to see board in the terminal
  def update_board(player, row, column)
    if board[row][column] == ('x' || 'o')
      raise ArgumentError
    else
      board[row][column] = player
    end
    self.save
   end

  # Returns the current_player
  # @return [String] 'x' or 'o'
  def current_player
    num_turns.even? ? "x" : "o"
  end

  # Checks for previous_player by comparing current_player
  def previous_player
    num_turns.odd? ? "x" : "o"  
  end

  # Plays the game
  # 
  # @returns winner
  # updates the board
  # call #WINNER AFTER each move, not before
  def play(row, column)
    update_board(current_player, row, column)
    if winner?
      return "Player #{previous_player} is the winner!"
    end
  end

  def game_over?
    winner? || num_turns > 8
  end

  # Checks if there is a winner.
  # @return [Boolean] returns true if there is a winner, false otherwise
  # Calls on private methods below
  def winner?(player=previous_player)
    check_rows_for_winner(player) || check_columns_for_winner(player) || check_diagonals_for_winner(player)
  end

  # The below methods can only be accessed by methods in this class
  private

  # Establishes winner in row
  def check_rows_for_winner(player)
    board.each do |row|
      return true if row.all? {|cell| cell == player}
    end
    return false
  end

  # Establishes winner in columns
  def check_columns_for_winner(player)
    count = 0
    for col in 0...3
      for row in 0...3
        count += 1 if board[row][col] == player
        return true if count == 3
      end
      count = 0
    end
    return false
  end

  # Establishes winner diagonally
  def check_diagonals_for_winner(player)
    count = 0
    for pos in 0...3
        count += 1 if board[pos][pos] == player
        return true if count == 3
    end
    count = 0
    for pos in 0...3
        count += 1 if board[pos][2-pos] == player
        return true if count == 3
    end
    return false
  end

  def num_turns
    count = 0
    for row in 0...3
      for col in 0...3
        count += 1 if board[row][col] == "x" || board[row][col] == "o"
      end
    end
    count
  end

end
