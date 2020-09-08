require_relative "tile"
require "byebug"

class Board

    def initialize(size)
        @board = populate_board(size)
    end

    def populate_board(size)
        bombs_arr = []
        bombs = size/10
        not_bombs = size - bombs

        bombs.times do
            bombs_arr << true
        end

        not_bombs.times do
            bombs_arr << false
        end

        Array.new(9) do
            Array.new(9) do
                rand_i = rand(bombs_arr.length)
                value = bombs_arr[rand_i]
                bombs_arr.delete_at(rand_i)
                Tile.new(value)
            end
        end
    end

    def render
        @board.each do |row|
            row.each{|tile| print tile.value + " "}
            puts
        end
    end


end

x = Board.new
x.render