class SegmentTree(T)
  @n : Int32
  @e : T
  @n0 : Int32
  @data : Array(T)

  def initialize(@n, @e)
    @n0 = 1 << (@n - 1).bit_length
    @data = Array.new(2 * @n0 - 1, @e)
  end
  def initialize(ary : Array(T), @e)
    @n = ary.size
    @n0 = 1 << (@n - 1).bit_length
    @data = Array.new(2 * @n0 - 1, @e)
    ary.each_with_index do |i, j|
      @data[j + @n0 - 1] = i
    end
    (@n0 - 2).downto(0) do |i|
      @data[i] = operate @data[i * 2 + 1], @data[i * 2 + 2]
    end
  end

  def update(i : Int32, x : T)
    i += @n0 - 1
    @data[i] = x
    while i > 0
      i = (i - 1) >> 1
      @data[i] = operate @data[i * 2 + 1], @data[i * 2 + 2]
    end
  end
  def find(l : Int32, r : Int32)
    l += @n0 - 1
    r += @n0 - 1
    res1 = @e
    res2 = @e
    while l < r
      res1 = operate res1, @data[l] if l & 1 == 0
      res2 = operate @data[r - 1], res2 if r & 1 == 0
      l >>= 1
      r = (r - 1) >> 1
    end
    operate(res1, res2)
  end

  def [](i : Int32)
    @data[i + @n0 - 1]
  end
  def []=(i : Int32, x : T)
    update(i, x)
  end

  def bsearch(i : Int32, f : Proc(T, Bool))
    return nil unless f.call(find(i, @n))
    l, r = i, i + 1
    idx = i + @n0 - 1
    x = @e
    until f.call(y = operate x, @data[idx])
      x = y
      if idx & 1 == 1
        r += r - l
      else
        l, r = r, r + (r - l) * 2
      end
      idx >>= 1
    end
    while idx < @n0 - 1
      y = operate x, @data[2 * idx + 1]
      if f.call y
        idx = 2 * idx + 1
        r -= r - l >> 1
      else
        x = y
        idx = 2 * idx + 2
        l += r - l >> 1
      end
    end
    l
  end

  private def operate(x : T, y : T)
  end
end
