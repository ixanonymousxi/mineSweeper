class Tile

    attr_reader :board

    def initialize(bomb, board)
        @revealed = false
        @bombed = bomb
        @flagged = false
        @board = board
    end

    def value
        return "B" if @bombed
        "N"
    end

    def flag
        @flagged = !@flagged
    end

    def reveal
        @revealed = true
    end

    def find_pos
        @board.board.each_with_index do |row, i|
            if row.include?(self)
                return [i,row.index(self)]
            end
        end
    end

    def neighbors(pos)
        x,y = pos
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
        # neighbors_pos_arr = []

        # if x == 0
        #     neighbors_pos_arr = [
        #     [(x+1),y],
        #     [(x+1),(y+1)],
        #     [(x+1),(y-1)],
        #     [x,(y+1)],
        #     [x,(y-1)]
        # ]
        # elsif x == board.length
        #     neighbors_pos_arr = [
        #     [(x-1),y],
        #     [(x-1),(y+1)],
        #     [(x-1),(y-1)],
        #     [x,(y+1)],
        #     [x,(y-1)]
        # ]
        # elsif y == 0
        #     neighbors_pos_arr = [
        #     [(x+1),y],
        #     [(x+1),(y+1)],
        #     [(x-1),y],
        #     [(x-1),(y+1)],
        #     [x,(y+1)]
        # ]
        # elsif y == board.length  
        #     neighbors_pos_arr = [
        #     [(x+1),y],
        #     [(x+1),(y-1)]
        #     [(x-1),y],
        #     [(x-1),(y-1)],
        #     [x,(y-1)]
        # ]  
        # else
        #     neighbors_pos_arr = [
        #     [(x+1),y],
        #     [(x+1),(y+1)],
        #     [(x+1),(y-1)],
        #     [(x-1),y],
        #     [(x-1),(y+1)],
        #     [(x-1),(y-1)],
        #     [x,(y+1)],
        #     [x,(y-1)]
        # ]
        # end

        # neighbors_pos_arr

    end

    def neighbor_bomb_count(pos,board)
        bomb_count = 0
        neighbors = self.neighbors(pos)
        neighbors.each do |neighbor|
            bomb_count += 1 if board[neighbor].value == "B"
        end
        bomb_count
    end

end
