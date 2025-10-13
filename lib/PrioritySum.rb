class MaxHeap < BinaryHeap
  def priority(a, b)
    a > b
  end
end

class MinHeap < BinaryHeap
  def priority(a, b)
    a < b
  end
end

class PrioritySum
  attr :k
  def initialize(k = 0, max = false)
    @k = k
    @max = max
    @l = (@max ? MinHeap.new : MaxHeap.new)
    @dell = (@max ? MinHeap.new : MaxHeap.new)
    @r = (@max ? MaxHeap.new : MinHeap.new)
    @delr = (@max ? MaxHeap.new : MinHeap.new)
    @sum = 0
  end
  def size
    @l.size + @r.size - @dell.size - @delr.size
  end
  def insert(x)
    if @l.empty? || compare(x, @l.top) then
      @l << x
      @sum += x
    else
      @r << x
    end
    opt
  end
  def delete(x)
    opt
    if compare(@l.top, x) then
      @delr << x
    else
      @dell << x
      @sum -= x
    end
  end
  alias << insert
  def sum
    @sum
  end

  private
  def compare(a, b)
    @max ? a > b : a < b
  end
  def opt
    until (lsize = @l.size - @dell.size) == @k || (lsize < @k && @r.empty?) do
      until @l.empty? || @l.top != @dell.top do
        @l.pop
        @dell.pop
      end
      until @r.empty? || @r.top != @delr.top do
        @r.pop
        @delr.pop
      end
      if lsize > @k then
        @sum -= @l.top
        @r << @l.pop
      else
        @sum += @r.top
        @l << @r.pop
      end
    end
  end
end
