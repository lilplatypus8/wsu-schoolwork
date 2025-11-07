# Josiah Schmitz

class BST

  # Node class to represent each node in the BST
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

  # Returns the number of items in the BST
  def size()
    @size
  end

  # Traverses the BST in-order, passing each item to the given block
  def each_inorder(&block)
    inorder_traversal(@root, &block)
  end

  # Traverses the BST in order and returns a BST with items passed to block
  def collect_inorder(&block)

    # Creates new BST to hold passed items (uses same comparison block)
    new_bst = BST.new(&@compare)

    # Uses each_inorder to add items transformed by block to new BST
    each_inorder { |value| new_bst.add(block.call(value)) }
    return new_bst
  end

  # Returns a sorted array of all items in the BST
  def to_a()
    array = []

    # Uses each_inorder to add items to array in sorted order
    each_inorder { |value| array.push(value) }
    return array
  end

  # Creates deep copy of BST
  def dup()

    # Creates new BST to hold passed items (uses same comparison block)
    new_bst = BST.new(&@compare)

    # Uses helper method to deep copy nodes recursively starting with root
    new_bst.root = copy_node(@root)
    new_bst.size = @size
    return new_bst
  end

  #-----------------------------------------------------------------------------
  # HELPER METHODS BELOW

  # Helper for compare block
  # Calls compare block if one is give, otherwise calls the <=> operator
  def compare(a, b)
    if @compare != nil
      return @compare.call(a, b)
    else
      return a <=> b
    end
  end

  # Helper method for recursive searching for include?
  def search(node, item)

    # Node to hold current position in tree
    current = node

    # BASE CASE: if current node is nil, item is not in the tree
    if current == nil
      return false
    end

    # Contains result of comparing the node's value to the item's
    compare_result = compare(item, current.value)

    # RECURSIVE CASE:
    # If item is equal to node, return true
    if compare_result == 0
      return true
    elsif compare_result == -1
      # If item is less than node, go left and call include? recursively
      return search(current.left, item)
    end

    # If item is greater than node, go right and call include? recursively
    return search(current.right, item)
  end

  # Helper method for recursive in-order traversal in each_inorder
  def inorder_traversal(node, &block)

    # BASE CASE: if node is nil, branch is fully searched
    if node == nil
      return
    end

    # RECURSIVE CASE: traverse left subtree, then visit node, then traverse right subtree
    inorder_traversal(node.left, &block)
    block.call(node.value)
    inorder_traversal(node.right, &block)
  end

  # Recursive helper method for deep copying nodes in dup
  def copy_node(node)

    # BASE CASE: If node is nil, return nil
    if node == nil
      return nil
    end

    # RECURSIVE CASE: Create new node with same value as original node and recursively copy left and right nodes
    new_node = Node.new(node.value)
    new_node.left = copy_node(node.left)
    new_node.right = copy_node(node.right)
    return new_node
  end
end
