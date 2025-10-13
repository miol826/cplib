class BinaryHeap
  def initialize
    @data = Array.new
  end
  def size
    @data.size
  end
  def empty?
    @data.size == 0
  end
  def insert(x)
    idx = @data.size
    @data << x
    while idx > 0 && priority(@data[idx], @data[(idx - 1) >> 1]) do
      @data[(idx - 1) >> 1], @data[idx] = @data[idx], @data[(idx - 1) >> 1]
      idx = (idx - 1) >> 1
    end
  end
  alias << insert
  def pop
    return nil if @data.size == 0
    return @data.pop if @data.size == 1
    r = @data[0].dup
    @data[0] = @data.pop
    idx = 0
    while (n_idx = 2 * idx + 1) < @data.size do
      n_idx += 1 if n_idx + 1 < @data.size && priority(@data[n_idx + 1], @data[n_idx])
      break if priority(@data[idx], @data[n_idx])
      @data[idx], @data[n_idx] = @data[n_idx], @data[idx]
      idx = n_idx
    end
    r
  end
  def top
    self.empty? ? nil : @data[0]
  end

  private
  def priority(a, b) # return true iff a has higher priority than b
  end
end
