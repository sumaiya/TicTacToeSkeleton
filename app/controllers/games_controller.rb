class GamesController < ApplicationController

  # Calling all Games!
	def index
    @games = Game.all
	end

  # Calling a new Game
  # redirect to show
	def new
		@game = Game.new
    @game.save!
    redirect_to :action => 'show', :id => @game.id
	end

  # Showing the game
  # @params 
  def show
    @game = Game.find(params[:id])
  end
  
  # Play game using @params
  # Flash winner
  # Make it viewable in show!
  def update
    @game = Game.find(params[:id])
    @game.play(params[:game][:row].to_i, params[:game][:column].to_i)
    if @game.winner?
     flash[:success] = "Player #{@game.previous_player} is the winner!"
    end
    redirect_to :action => 'show', :id => @game.id
  end
end
