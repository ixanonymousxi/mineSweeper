require_relative "board"
require "byebug"
require 'yaml'

class MineSweeper

    attr_reader :board
    
    def initialize(size)
        @size = size
        @board = Board.new(size)
        @quit = false
        @exit = false
    end

    def save_game
        puts "Please name your save file"
        print ">"
        file_name = gets.chomp
        puts "Game saved!"

        games_list = YAML.load(File.read("yaml_games.txt"))
        
        if games_list.kind_of?(Array)
            games_list << {"instance" => self, "name" => file_name}
        else
            games_list = [{"instance" => self, "name" => file_name}]
        end

        File.open("yaml_games.txt", "w") { |file| file.write(games_list.to_yaml) }

        quit?
    end

    def quit?
        puts "Do you want to continue?"
        puts "Type 'Q' to quit or 'C' to continue."
        print ">"

        input = gets.chomp
        if input == "Q" || input == "q"
            @quit = true
        elsif input == "C" || input == "c"
            run
        else
            puts "Invalid input. Please try again."
            quit?
        end
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts
            puts "If you want to quit game, press Q. If you want to save game, press S."
            puts "If you want to (un)flag a tile, press F."
            puts "Otherwise, enter a position on the board. Ex: 2,3."
            print ">"
            
            pos = parse_pos(gets.chomp)

            if !valid_pos?(pos)
                puts "Invalid position entered. (Did you use a comma?)"
                puts ""
                get_pos
            end
        end
        pos
    end

    def parse_pos(string)
        return "F" if string == "F" || string == "f"
        return "X" if string == "X" || string == "x"
        return "Q" if string == "Q" || string == "q"
        return "S" if string == "S" || string == "s"
        string.split(",").map{|ele| Integer(ele)}
    end

    def valid_pos?(pos)
        (pos.is_a?(Array) && 
        pos.length == 2 && 
        pos.all?{|num| num >= 0 && num < @size} && 
        (@board[pos].value == "*" || @board[pos].value == "F")) ||
         pos == "F" || 
         pos == "X" ||
         pos == "S" ||
         pos == "Q"
    end

    def get_flag_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts
            puts "Enter a position on the board to flag. Ex: 2,3. Type 'X' to cancel."
            print ">"

            pos = parse_pos(gets.chomp)

            if !valid_pos?(pos)
                puts "Invalid position entered. (Did you use a comma?)"
                puts ""
                get_flag_pos
            end
        end
        pos
    end

    def play_turn
        pos = get_pos

        if pos == "F"
            pos = get_flag_pos
            if pos == "X"
                play_turn
            else
                @board[pos].flag
            end
        elsif pos == "X"
            play_turn
        elsif pos == "S"
            save_game
        elsif pos == "Q"
            quit?
        elsif @board[pos].flagged == true
            play_turn
        else
            @board[pos].reveal
        end
    end

    def game_over?
        if @board.win?
            puts
            puts "You Win!"
            puts
            return true
        elsif @board.lose?
            puts
            puts "You hit a bomb. You lose."
            puts
            return true
        end
        false
    end

    def start
        @quit = false
        puts "If you want to start a new game type 'N'." 
        puts "If you want to load a saved game type 'S'."
        puts "If you want to delete a saved game type 'D'."
        puts "If you want to exit the game type 'E'."
        print ">"
        input = gets.chomp

        games_list = YAML.load(File.read("yaml_games.txt"))

        if input == "N" || input == "n"
            self.run
        elsif (input == "S" || input == "s" || input == "D" || input == "d") && (!games_list.kind_of?(Array) || games_list.length == 0)
            puts "No saved games available"
            start
        elsif input == "S" || input == "s"
            loadGame
        elsif input == "D" || input == "d"
            deleteGame
        elsif input == "E" || input == "e"
            @exit = true
        else
            puts "Invalid input. Please try again"
            start    
        end
    end

    def loadGame
        puts "Please select a number to load or type 'X' to go back."
        puts

        games_list = YAML.load(File.read("yaml_games.txt"))
        games_list.each_with_index  do |hash, i|
            print (i+1).to_s + ". " + hash["name"]
            puts
        end

        choice = gets.chomp

        if choice == "X" || choice == "x"
            start
        elsif choice.to_i > 0 && choice.to_i <= games_list.length
            games_list[choice.to_i - 1]["instance"].run
        else
            puts "Invalid input. Please try again"
            loadGame
        end
    end

    def deleteGame
        puts "Please select a number to delete or type 'X' to go back."
        puts
        games_list = YAML.load(File.read("yaml_games.txt"))
        games_list.each_with_index  do |hash, i|
            print (i+1).to_s + ". " + hash["name"]
            puts
        end

        choice = gets.chomp

        if choice == "X" || choice == "x"
            start
        elsif choice.to_i > 0 && choice.to_i <= games_list.length
            games_list.delete_at(choice.to_i - 1)
            File.open("yaml_games.txt", "w") { |file| file.write(games_list.to_yaml) }
            start
        else
            puts "Invalid input. Please try again"
            deleteGame
        end
    end

    def run
        until @exit
            @board.render
            until game_over? || @quit
                play_turn
                @board.render
            end
            start
        end
    end

end


#$exit = false

# def start
#     puts "If you want to start a new game type 'N'." 
#     puts "If you want to load a saved game type 'S'."
#     puts "If you want to delete a saved game type 'D'."
#     puts "If you want to exit the game type 'E'."
#     print ">"
#     input = gets.chomp

#     games_list = YAML.load(File.read("yaml_games.txt"))

#     if input == "N" || input == "n"
#         x = MineSweeper.new(9)
#         x.run
#     elsif (input == "S" || input == "s" || input == "D" || input == "d") && !games_list.kind_of?(Array)
#         puts "No saved games available"
#         start
#     elsif input == "S" || input == "s"
#         loadGame
#     elsif input == "D" || input == "d"
#         deleteGame
#     elsif input == "E" || input == "e"
#         $exit = true
#     else
#         puts "Invalid input. Please try again"
#         start    
#     end
# end

# def loadGame
#     puts "Please select a number to load or type 'X' to go back."
#     puts

#     games_list = YAML.load(File.read("yaml_games.txt"))
#     games_list.each_with_index  do |hash, i|
#         print (i+1).to_s + ". " + hash["name"]
#         puts
#     end

#     choice = gets.chomp

#     if choice == "X" || choice == "x"
#         start
#     elsif choice.to_i > 0 && choice.to_i <= games_list.length
#         games_list[choice.to_i - 1]["instance"].run
#     else
#         puts "Invalid input. Please try again"
#         loadGame
#     end
# end

# def deleteGame
#     puts "Please select a number to delete or type 'X' to go back."
#     puts
#     games_list = YAML.load(File.read("yaml_games.txt"))
#     games_list.each_with_index  do |hash, i|
#         print (i+1).to_s + ". " + hash["name"]
#         puts
#     end

#     choice = gets.chomp

#     if choice == "X" || choice == "x"
#         start
#     elsif choice.to_i > 0 && choice.to_i <= games_list.length
#         games_list.delete_at(choice.to_i - 1)
#         File.open("yaml_games.txt", "w") { |file| file.write(games_list.to_yaml) }
#         start
#     else
#         puts "Invalid input. Please try again"
#         deleteGame
#     end
# end

# while(!$exit)
#     start
# end


x = MineSweeper.new(9)
x.start

# puts
#print x
#print x.board
# puts
#print x.board.board
#print x.board[[0,0]]
# puts