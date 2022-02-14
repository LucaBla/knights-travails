class Node
  attr_accessor :children, :field

  def initialize(field)
    @field = field
    @children = []
  end
end

class Tree
  def initialize(root)
    @root = Node.new(root)
  end

  def build_tree(arr, knight, root = @root)
    knight.moves.each do |move|
      p move[0] + root.field[0]
      p move[1] + root.field[1]
      puts
      if (root.field[0] + move[0] >= 0 || root.field[0] + move[0] <= 7) && (root.field[1] + move[1] >= 0 || root.field[1] + move[1] <= 7)
        new_child = [root.field[0] + move[0], root.field[1] + move[1]]
        p "new child is #{new_child} #{arr.include?(new_child)}"
        if arr.include?(new_child)
          p 'hallo'
          root.children.push(Node.new(new_child))
          arr.delete(new_child)
        end
      end
    end
    p arr
  end

  def print_tree(root = @root, spaces = '')
    return if root.nil?

    puts "#{spaces}#{root.field}"
    return if root.children.empty?

    puts "#{spaces}children"
    spaces += '  '
    root.children.each { |child| print_tree(child, spaces) }
  end
end

class Board
  attr_accessor :fields, :missing_fields

  def initialize
    @fields = create_board
    @missing_fields = create_missing_fields
  end

  def create_board
    arr = Array.new(8)
    arr.map! { Array.new(8, 1) }
    arr.each_with_index do |x, i|
      x.map!.with_index do |_, i2|
        [i, i2]
      end
    end
    arr
  end

  def create_missing_fields
    arr = []
    @fields.each do |x|
      x.each {|y| arr.push(y)}
    end
    arr
  end
end

class Knight
  attr_accessor :moves

  def initialize(position)
    @moves = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
    @position = position
    @possible_moves = []
  end
end

b = Board.new
t = Tree.new([3, 3])
t.build_tree(b.missing_fields, Knight.new([3, 3]))
p b.missing_fields
p t.print_tree
