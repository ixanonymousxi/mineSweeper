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
        @board = @board.map.with_index do |row, i|
            row.map.with_index do |val, j|
                Tile.new(val,self, [i,j])
            end
        end
    end

    def [](pos)
        x,y = pos
        @board[x][y]
    end

    def render
        puts "   #{(0..8).to_a.join(" ")}"
        @board.each_with_index do |row, i|
            print i.to_s + "  "
            row.each{|tile| print tile.value + " "}
            puts
        end
    end


end

x = Board.new(9)
x.populate_board
puts
x.render
# print x[[8,8]].value
# puts
# print x[[8,8]]
# puts
# print x[[8,8]].pos
# puts
# print x[[8,8]].neighbors
# puts
# print x[[8,8]].neighbor_bomb_count
# puts
