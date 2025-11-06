# Josiah Schmitz

class BST
  class Node
    attr_accessor :value, :left, :right

    def initialize(value)
      @value = value
      @left = nil
      @right = nil
    end
  end

  attr_accessor :root, :compare, :size

  # Constructor to intialize the BST with a comparison block and null root
  def initialize(&block)
    @compare = block
    @size = 0
    @root = nil
  end

  # Adds given item to BST using comparison block
  def add(item)

    # If the root is empty, make item the root and increment size
    if @root == nil
      @root = Node.new(item)
      @size += 1
      return item # Return the added item
    end

    # Node to hold current position in tree
    current = @root

    # Loops until an empty node is found to insert the item
    loop do
      # Contains result of comparing the root's value to the item's
      compare_result = @compare.call(@root, item)

      if compare_result = -1
        # If item is less than root, go left
        if current.left == nil
          current.left = Node.new(item)
          @size += 1
          return item # Return the added item
        else
          current = current.left
        end
      else
        # If item is greater than root or a duplicate of root, go right
        if current.right == nil
          current.right = Node.new(item)
          @size += 1
          return item # Return the added item
        else
          current = current.right
        end
      end
    end
  end

  # Returns true if BST is empty, false otherwise
  def empty?
    @size == 0
  end
end
