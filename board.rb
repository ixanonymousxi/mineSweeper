require_relative "tile"
require "byebug"

class Board

    attr_reader :board

    def initialize(size)
        @board = create_board(size*size)
    end

    def create_board(size)
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
                value
                #Tile.new(value,@board)
            end
        end
    end

    def populate_board
        @board = @board.map do |row|
            row.map do |val|
                Tile.new(val,self)
            end
        end
    end

    def [](pos)
        x,y = pos
        @board[x][y]
    end

    def render
        @board.each do |row|
            row.each{|tile| print tile.value + " "}
            puts
        end
    end


end

x = Board.new(9)
#print x.board
x.populate_board
puts
#print x.board
x.render
print x[[8,8]].value
puts
#print x[[8,8]].board.render
puts
print x[[8,8]].find_pos