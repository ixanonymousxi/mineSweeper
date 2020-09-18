require_relative "tile"
require 'colorize'
require "byebug"

class Board

    attr_reader :board

    def initialize(size)
        @board = create_board(size*size)
        self.populate_board
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

        length = Math.sqrt(size)

        Array.new(length) do
            Array.new(length) do
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

    def colors(val)
        case val
            when "F"
            val.colorize(:magenta)
            when "*"
            val.colorize(:light_black)
            when "B"
            val.colorize(:red)
            when "_"
            val.colorize(:black)
            when "1"
            val.to_s.colorize(:green)
            when "2"
            val.to_s.colorize(:blue)
            when "3"
            val.to_s.colorize(:cyan)
            when "4"
            val.to_s.colorize(:light_green)
            else
            val
        end
    end

    def render
        puts
        puts "   #{(0..8).to_a.join(" ")}"
        @board.each_with_index do |row, i|
            print i.to_s + "  "
            row.each{|tile| print colors(tile.value) + " "}
            puts
        end
    end

    def win?
        #@board.none?{|row| row.none?{|tile| tile.bombed == true && tile.revealed == true}} &&
        @board.all? do |row| 
            row.all? do |tile|
                if tile.bombed == false
                    tile.revealed == true
                else
                    tile.revealed == false
                end
            end
        end         
    end

    def lose?
        @board.any?{|row| row.any?{|tile| tile.bombed == true && tile.revealed == true}}
    end

end

# x = Board.new(9)
# x.populate_board
# puts
# x.render
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
# print x[[8,8]].board.board.length
# puts
