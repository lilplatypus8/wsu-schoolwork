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

  # Helper for compare block
  # Calls compare block if one is give, otherwise calls the <=> operator
  def compare(a, b)
    if @compare != nil
      return @compare.call(a, b)
    else
      return a <=> b
    end
  end

  # Adds given item to BST using comparison block
  def add(item)

    # If the root is empty, make item the root and increment size
    if @root == nil
      @root = Node.new(item)
      @size += 1
      return self # Return the object
    end

    # Node to hold current position in tree
    current = @root

    # Loops until an empty node is found to insert the item
    loop do
      # Contains result of comparing the node's value to the item's
      compare_result = compare(item, current.value)

      if compare_result == -1
        # If item is less than node, go left
        if current.left == nil
          current.left = Node.new(item)
          @size += 1
          return self # Return the object
        else
          current = current.left
        end
      else
        # If item is greater than root or a duplicate of root, go right
        if current.right == nil
          current.right = Node.new(item)
          @size += 1
          return self # Return the object
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

  # Returns true if item is in the BST, false otherwise
  def include?(item)
    return search(@root, item)
  end

  # Helper method for recursive searching for include?
  def search(node, item)

    # Node to hold current position in tree
    current = node

    # If current node is nil, item is not in the tree
    if current == nil
      return false
    end

    # Contains result of comparing the node's value to the item's
    compare_result = compare(item, current.value)

    # If item is equal to node, return true
    if current.value == item
      return true
    elsif compare_result == -1
      # If item is less than node, go left and call include? recursively
      return search(current.left, item)
    end

    # If item is greater than node, go right and call include? recursively
    return search(current.right, item)
  end

  # Returns the number of items in the BST
  def size()
    @size
  end

  # Traverses the BST in-order, passing each item to the given block
  def each_inorder(&block)
    inorder_traversal(@root, &block)
  end

  # Helper method for recursive in-order traversal in each_inorder
  def inorder_traversal(node, &block)

    # If node is nil, branch is fully searched
    if node == nil
      return
    end

    # Traverse left subtree, then visit node, then traverse right subtree
    inorder_traversal(node.left, &block)
    block.call(node.value)
    inorder_traversal(node.right, &block)
  end

  # Returns a sorted array of all items in the BST
  def to_a()
    array = []

    # Uses each_inorder to add items to array in sorted order
    each_inorder { |value| array.push(value) }
    return array
  end
end

# Test code:
tree = BST.new
tree.add(5).add(3).add(7).add(2).add(4).add(6).add(8)
puts "Tree: #{tree.to_a()}\n"
puts "Size: #{tree.size()}\n"
puts "Includes 4? #{tree.include?(4)}"
puts "Includes 9? #{tree.include?(9)}\n"
puts "Empty? #{tree.empty?}\n"
