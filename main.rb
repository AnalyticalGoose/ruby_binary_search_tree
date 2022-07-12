class Tree
    attr_accessor :array, :root

    def initialize(array)
        @array = array.sort.uniq
        @root = build_tree(@array)
    end

    def build_tree(array)
        return nil if array.empty?  

        m = (array.size - 1)/2    
        root = Node.new(array[m])           
        root.left = build_tree(array[0...m])         
        root.right = build_tree(array[m+1..-1])        
        return root
    end

    def insert(value, root = @root)
        return Node.new(value) if root.nil?
        return root if root.data == value

        if root.data < value 
            root.right = insert(value, root.right)
        else 
            root.left = insert(value, root.left)
        end
        return root
    end

    def delete(value, root = @root)
        return root if root.nil?
        
        if root.data < value
            root.right = delete(value, root.right)
            return root
        elsif root.data > value
            root.left = delete(value, root.left)
            return root
        else
            # check for childfree parent (or one child..)
            return root.right if root.left.nil?
            return root.left if root.right.nil?

            # Unlucky parent with two children
            root.data = find_leaf(root.right)
            root.right = delete(root.data, root.right) 
        end
        return root
    end

    def find(value, root = @root)
        return root if root.nil? || root.data == value
        root.data < value ? find(value, root.right) : find(value, root.left)
    end

    def find_leaf(node = @root)
        return node.data if node.left.nil?
        find_leaf(node.left)
    end

    def level_order(stack = [], order = [], root = @root)
        stack << root.left unless root.left.nil?
        stack << root.right unless root.right.nil?
        order << root.data
        
        yield(root.data) if block_given?
        return if stack.empty?

        level_order(stack, order, stack.shift)
        return order
    end

    def inorder(stack = [], order = [], root = @root)
        return nil if root.nil?
        yield(root.data) if block_given?
        
        inorder(stack, order, root.left)
        order << root.data
        inorder(stack, order, root.right)

        return order
    end

    def preorder(stack = [], order = [], root = @root)
        return nil if root.nil?
        yield(root.data) if block_given?

        order << root.data
        preorder(stack, order, root.left)
        preorder(stack, order, root.right)

        return order
    end

    def postorder(stack = [], order = [], root = @root)
        return nil if root.nil?
        yield(root.data) if block_given?

        postorder(stack, order, root.left)
        postorder(stack, order, root.right)
        order << root.data

        return order
    end

    def height(node)
        unless node.nil? || node == root
            node = (node.instance_of?(Node) ? find(node.data) : find(node))
        end 
        return -1 if node.nil? 
        [height(node.left), height(node.right)].max + 1
    end

    def depth(node, root = @root, dist = -1)
        return -1 if root.nil?
        return dist + 1 if root.data == node

        dist = depth(node, root.left, dist)
        return dist +1 if dist >= 0
        dist = depth(node, root.right, dist)
        return dist +1 if dist >= 0
        
        return dist   
    end

    def balanced?(root = @root)
        return true if root.nil?
        
        l_height = height(root.left)
        r_height = height(root.right)

        return true if (l_height - r_height).abs <= 1 && balanced?(root.left) && balanced?(root.right)
        
        return false
    end

    def rebalance
        @root = build_tree(inorder)
    end

    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
end

class Node
    include Comparable
    attr_accessor :data, :left, :right

    def initialize(data)
        @data = data
        @left = nil
        @right = nil
    end
end



bst = Tree.new((Array.new(15) { rand(1..100) }))

puts bst.balanced? == true ? "The tree is balanced" : "The tree is unbalanced"

puts "\nLevel-order : #{bst.level_order} \nInorder : #{bst.inorder} 
Preorder : #{bst.preorder} \nPostorder : #{bst.postorder}\n "

10.times { bst.insert(rand(100..200)) }

puts bst.balanced? == true ? "The tree is balanced" : "The tree is unbalanced \n "

bst.rebalance

puts bst.balanced? == true ? "The tree is balanced \n " : "The tree is unbalanced"

puts "\nLevel-order : #{bst.level_order} \nInorder : #{bst.inorder} 
Preorder : #{bst.preorder} \nPostorder : #{bst.postorder}\n "

puts bst.pretty_print