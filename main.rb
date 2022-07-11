
require 'pry'

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
        return nil if root.nil? || root.data == value
        root.data < value ? find(value, root.right) : find(value, root.left)
    end

    def find_leaf(node = @root)
        return node.data if node.left.nil?
        find_leaf(node.left)
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


# arr = (Array.new(15) { rand(1..100) })

arr = [1, 2, 3, 4, 5, 6, 7]
bst = Tree.new(arr)

puts bst.pretty_print
# p bst