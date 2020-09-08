class Tile

    def initialize(bomb)
        @revealed = false
        @bombed = bomb
        @flagged = false
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

    def neighbors
    end

    def neighbor_bomb_count
    end

end
