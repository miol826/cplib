class SegmentTree
  def initialize(n, e)
    @n = (arr = Array.try_convert(n))&.size || n
    @n0 = 1 << (@n - 1).bit_length
    @e = e
    @data = Array.new(2 * @n0 - 1)
    i = 2 * @n0 - 2
    while i >= 0 do
      if i >= @n0 - 1 then
        @data[i] = arr && i - @n0 + 1 < @n ? arr[i - @n0 + 1] : @e.dup
      else
        @data[i] = operate(@data[(i << 1) + 1], @data[(i << 1) + 2])
      end
      i -= 1
    end
  end
  def apply(i, x)
    i += @n0 - 1
    @data[i] = x
    while i > 0 do
      i = (i - 1) >> 1
      @data[i] = operate(@data[(i << 1) + 1], @data[(i << 1) + 2])
    end
  end
  def product(l, r)
    l += @n0 - 1
    r += @n0 - 1
    res1 = @e
    res2 = @e
    while l < r do
      res1 = operate(res1, @data[l]) if l[0] == 0
      res2 = operate(@data[r - 1], res2) if r[0] == 0
      l >>= 1
      r = (r - 1) >> 1
    end
    operate(res1, res2)
  end
  def [](i)
    @data[i + @n0 - 1]
  end
  alias []= apply
  private
  def operate(x, y)
  end
end
