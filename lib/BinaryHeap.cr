class BinaryHeap(T)
  def initialize
    @data = Array(T).new
  end
  def size
    @data.size
  end
  def empty?
    @data.size == 0
  end
  def insert(x : T)
    idx = @data.size
    @data << x
    while idx > 0 && priority(@data[idx], @data[(idx - 1) >> 1])
      @data[(idx - 1) >> 1], @data[idx] = @data[idx], @data[(idx - 1) >> 1]
      idx = (idx - 1) >> 1
    end
  end
  def <<(x : T)
    insert x
  end
  def pop? : (T | Nil)
    return nil if @data.size == 0
    return @data.pop if @data.size == 1
    r = @data[0].dup
    @data[0] = @data.pop
    idx = 0
    while (n_idx = 2 * idx + 1) < @data.size
      n_idx += 1 if n_idx + 1 < @data.size && priority(@data[n_idx + 1], @data[n_idx])
      break if priority(@data[idx], @data[n_idx])
      @data[idx], @data[n_idx] = @data[n_idx], @data[idx]
      idx = n_idx
    end
    r
  end
  def pop : T
    r = self.pop?
    raise IndexError.new if r.nil?
    r
  end
  def top : T
    raise IndexError.new if @data.empty?
    @data[0]
  end
  def top? : (T | Nil)
    self.empty? ? nil : @data[0]
  end

  private def priority(a, b) # return true iff a has higher priority than b
  end
end
