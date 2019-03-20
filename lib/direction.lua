local direction = {}

direction.up = 0
direction.right = 1
direction.down = 2
direction.left = 3

function direction.turn(dir, positions)
    return (dir + positions) % 4
end

function direction.is_opposite(dir1, dir2)
    return direction.turn(dir2, 2) == dir1
end

function direction.is_same_axis(dir1, dir2)
    return dir1 == dir2 or direction.is_opposite(dir1, dir2)
end

function direction.is_adjacent(dir1, dir2)
    return not direction.is_on_same_axis(dir1, dir2)
end

function direction.get_increment(dir)
    return (dir == direction.right or dir == direction.down) and 1 or -1
end

return direction