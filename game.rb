require_relative "board"
require "byebug"

class MineSweeper

    attr_reader :board
    
    def initialize(size)
        @size = size
        @board = Board.new(size)
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts
            puts "If you want to flag a tile, press F. Otherwise, enter a position on the board. Ex: 2,3."
            print ">"
            begin
                pos = parse_pos(gets.chomp)
            rescue
                puts "Invalid position enterd. (Did you usea comma?)"
                puts ""
                pos = nil
            end
        end
        pos
    end

    def parse_pos(string)
        return "F" if string == "F" || string == "f"
        return "X" if string == "X" || string == "x"
        string.split(",").map{|ele| Integer(ele)}
    end

    def valid_pos?(pos)
        pos.is_a?(Array) && pos.length == 2 && pos.all?{|num| num >= 0 && num < @size} && @board[pos].value == "*" || pos == "F" || pos == "X"
    end

    def get_flag_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts
            puts "Enter a position on the board to flag. Ex: 2,3. Type 'X' to cancel."
            print ">"
            begin
                pos = parse_pos(gets.chomp)
            rescue
                puts "Invalid position enterd. (Did you usea comma?)"
                puts ""
                pos = nil
            end
        end
        pos
    end

    def play_turn
        pos = get_pos

        if pos == "F"
            pos = get_flag_pos
            @board[pos].flag
        elsif pos == "X"
            pos = get_pos
            @board[pos].reveal
        else
            @board[pos].reveal
        end
    end

    def game_over?
        if @board.board.all?{|row| row.all?{|tile| tile.value != "*"}}
            puts
            puts "You Win!"
            puts
            return true
        end
        false
    end

    def run
        @board.render
        until game_over?
            play_turn
            @board.render
        end
    end

end

x = MineSweeper.new(9)
x.run
# puts
#print x
#print x.board
# puts
#print x.board.board
#print x.board[[0,0]]
# puts