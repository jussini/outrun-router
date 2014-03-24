
class Node
  attr_accessor :likes
  attr_accessor :routeparent

  def initialize(likes = 0)
    clear(likes)
  end

  def clear(likes)
    @likes = likes
    @routeparent = nil
  end

end


class NodeHelper
    def self.left_parent(parentline, i)
    if i == 0 or parentline.nil?
      nil
    else
      parentline[i-1]
    end
  end

  def self.right_parent(parentline, i, line_i)
    if parentline.nil? or i >= line_i
      nil
    else
      parentline[i]
    end
  end

  def self.choose_parent (left, right)
    if left.nil? and right.nil?
      nil
    elsif left.nil?
      right
    elsif right.nil?
      left
    elsif left.likes > right.likes
      left
    else
      right
    end
  end
end

class OutrunRouter

  def initialize(route_likes)
    @buffers = []
    @buffers.push(Array.new(route_likes.length) {Node.new});
    @buffers.push(Array.new(route_likes.length) {Node.new});
    @route_likes = route_likes
  end


  def get_max_likes
    maxnode = Node.new
    @route_likes.each_with_index do
      |likes_line, likes_line_index|

      @buffers.rotate! 1
      nodeline = @buffers [0]
      parentline = @buffers [1]

      likes_line.split.each_with_index do
        |likes, likes_index|

        n = nodeline[likes_index]
        n.clear likes.to_i

        # which parent has more accumulated likes
        lparent = NodeHelper.left_parent parentline, likes_index
        rparent = NodeHelper.right_parent parentline, likes_index, likes_line_index
        p = NodeHelper.choose_parent lparent, rparent

        # set the parent to the one with more likes
        n.routeparent = p

        # set accumulated likes of current node
        if not p.nil?
          n.likes = n.likes + p.likes.to_i
        end

        # keep track of the node to which has most accummulated likes
        if n.likes > maxnode.likes
          maxnode = n
        end
      end
    end

    maxnode.likes
  end
end


if __FILE__ == $0
  starttime = Time.now

  lines = IO.readlines(ARGV[0])
  linecount = lines.count
  diff = (Time.now - starttime) * 1000
  puts "Reading file with #{linecount} lines took #{diff} ms"

  router = OutrunRouter.new lines
  diff = (Time.now - starttime) * 1000 -diff
  puts "Initialized routed in #{diff} ms"
  
  # not a commend and at least something on line and newline
  lines.select! {|l| (not l.start_with? "#") and l.length > 1}
  diff = (Time.now - starttime) * 1000 - diff
  puts "Filtering lines took #{diff} ms"

  max_likes = router.get_max_likes
  diff = (Time.now - starttime) * 1000 -diff
  puts "Found max_likes in #{diff} ms"
  puts "Max likes: #{max_likes}"
  
end

