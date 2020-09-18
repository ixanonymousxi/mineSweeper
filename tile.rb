require "byebug"

class Tile

    attr_reader :board, :bombed, :pos, :revealed, :flagged
    attr_writer  :revealed

    def initialize(bomb, board, pos)
        @revealed = false
        @bombed = bomb
        @flagged = false
        @board = board
        @pos = pos
    end

    def value
        return "F" if @flagged
        return "*" if !@revealed
        return "B" if @bombed
        return self.neighbor_bomb_count.to_s if self.neighbor_bomb_count > 0
        return "_" if self.neighbor_bomb_count == 0
    end

    def flag
        @flagged = !@flagged
    end

    def reveal
        @revealed = true

        if self.bombed == true
            @board.board.each {|row| row.each{|tile| tile.revealed = true} }
        end

        if self.neighbor_bomb_count == 0
            self.reveal_neighbors
        end
    end

    def reveal_neighbors
        neighbors = self.neighbors
        neighbors.each do |neighbor|
            x,y = neighbor
            # if x >= 0 && x < 9 && y >= 0 && y < 9
            #     if @board.board[x][y].bombed == false && @board.board[x][y].flagged == false
            #         @board.board[x][y].reveal
            #     end
            # end
            if x >= 0 && x < @board.board.length && y >= 0 && y < @board.board.length
                if @board[neighbor].bombed == false && @board[neighbor].value != "F" && @board[neighbor].value == "*"
                    @board[neighbor].reveal
                end
            end
        end
    end

    def neighbors
        x,y = @pos

        neighbors_pos_arr = [
            [(x+1),y],
            [(x+1),(y+1)],
            [(x+1),(y-1)],
            [(x-1),y],
            [(x-1),(y+1)],
            [(x-1),(y-1)],
            [x,(y+1)],
            [x,(y-1)]
        ]
    end

    def neighbor_bomb_count
        bomb_count = 0
        neighbors = self.neighbors
        neighbors.each do |neighbor|
            x,y = neighbor
            if x >= 0 && x < @board.board.length && y >= 0 && y < @board.board.length
                #bomb_count += 1 if @board.board[x][y].bombed == true
                bomb_count += 1 if @board[neighbor].bombed == true
            end
        end
        bomb_count
    end

end
