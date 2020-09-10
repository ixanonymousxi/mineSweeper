require "byebug"

class Tile

    attr_reader :board, :bombed, :pos

    def initialize(bomb, board, pos)
        @revealed = false
        @bombed = bomb
        @flagged = false
        @board = board
        @pos = pos
    end

    def value
        #return "*" if !@revealed
        return "B" if @bombed
        return self.neighbor_bomb_count.to_s if self.neighbor_bomb_count > 0
        return "_" if self.neighbor_bomb_count == 0
    end

    def flag
        @flagged = !@flagged
    end

    def reveal
        @revealed = true
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
            if x >= 0 && x < 9 && y >= 0 && y < 9
                bomb_count += 1 if @board.board[x][y].bombed == true
            end
        end
        bomb_count
    end

end
