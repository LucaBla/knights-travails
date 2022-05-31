MOVES = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]].freeze
POSSIBLE_COLUMNS = %w[a b c d e f g h].freeze
POSSIBLE_ROWS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

class Node
  attr_accessor :children, :field, :parent

  def initialize(field)
    @field = field
    @children = []
    @parent = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(root, board)
    @root = Node.new(root)
    @board = board
  end

  def build_tree(root = @root)
    return if @board.missing_fields.empty?

    find_children(root)
    root.children.each do |child|
      find_children(child)
    end
    root.children.each do |child|
      build_tree(child)
    end
  end

  def find_children(root = @root)
    MOVES.each do |move|
      if (root.field[0] + move[0] >= 0 || root.field[0] + move[0] <= 7) && (root.field[1] + move[1] >= 0 || root.field[1] + move[1] <= 7)
        new_child = [root.field[0] + move[0], root.field[1] + move[1]]
        if @board.missing_fields.include?(new_child)
          @board.missing_fields.delete(new_child)
          new_child = Node.new(new_child)
          new_child.parent = root
          root.children.push(new_child)
        end
      end
    end
  end

  def preorder(target, way = [], root = @root)
    return root if root.nil?

    if root.field == target
      way.push(root.field) unless way.include?(target)
      until way.include?(@root.field)
        way.push(root.parent.field)
        root = root.parent
      end
    end
    root.children.each { |child| preorder(target, way, child) }
    way
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
      x.each { |y| arr.push(y) }
    end
    arr
  end
end

class Knight
  def initialize(position = [0, 0])
    @position = position
    @board = Board.new
    @tree = Tree.new(position, @board)
  end

  def set_start
    puts 'Pls enter the start coordinates of your knight. (Like a3 or c6)'
    set_position
  end

  def set_destination
    puts 'Pls enter the destination coordinates of your knight. (Like a3 or c6)'
    set_position
  end

  def set_position
    input = '  '
    input = gets.chomp.reverse.split(//) until POSSIBLE_COLUMNS.include?(input[1].downcase) &&
                                               POSSIBLE_ROWS.include?(input[0].to_i)
    input[0] = POSSIBLE_ROWS.index(input[0].to_i)
    input[1] = POSSIBLE_COLUMNS.index(input[1])
    input
  end

  def knight_moves(start, destination)
    @position = start
    @tree.root = Node.new(start)
    @tree.build_tree
    shortest_path = @tree.preorder(destination).reverse
    puts "=> You made it in #{shortest_path.length - 1} moves! Here's your path:"
    shortest_path.each do |field|
      field[1] = POSSIBLE_COLUMNS[field[1]]
      field[0] += 1
      p field.reverse
    end
  end
end

k = Knight.new
k.knight_moves(k.set_start, k.set_destination)
