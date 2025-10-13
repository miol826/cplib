class LazySegmentTree
  def initialize(n, e, act_e)
    @n = n
    @log = (n - 1).bit_length
    @n0 = 1 << @log
    @e = e
    @act_e = act_e
    @data = Array.new(2 * @n0 - 1, e)
    @act = Array.new(2 * @n0 - 1, act_e)
  end
  def update(l, r, m)
    ev_all_ancestor(l, r)
    lidx = l + @n0 - 1
    ridx = r + @n0 - 1
    while lidx < ridx do
      if lidx[0] == 0 then
        @act[lidx] = m
        ev lidx
      end
      if ridx[0] == 0 then
        @act[ridx - 1] = m
        ev(ridx - 1)
      end
      lidx >>= 1
      ridx = (ridx - 1) >> 1
    end
    lidx = l + @n0
    ridx = r + @n0 - 1
    1.upto(@log) do |i|
      lidx >>= 1
      r = (r - 1) >> 1
      @data[lidx - 1] = operate(@data[lidx - 1 << 1], @data[(lidx - 1 << 1) + 1])
    end
  end
  def find(l, r)
    ev_all_ancestor(l, r)
    l += @n0 - 1
    r += @n0 - 1
    res1 = @e
    res2 = @e
    while l < r do
      res1 = operate(res1, @data[l]) if l & 1 == 0
      res2 = operate(@data[r - 1], res2) if r & 1 == 0
      l >>= 1
      r = (r - 1) >> 1
    end
    operate(res1, res2)
  end
  private
  def ev_all_ancestor(l, r)
    lidx = l + @n0
    ridx = r + @n0 - 1
    @log.downto(0) do |i|
      ev((lidx >> i) - 1)
      ev((ridx >> i) - 1)
    end
  end
  def ev(i)
    unless @act[i] == @act_e then
      if i < @n0 - 1 then
        @act[(i << 1) + 1] = composition(@act[i], @act[(i << 1) + 1])
        @act[(i << 1) + 2] = composition(@act[i], @act[(i << 1) + 2])
      end
      @data[i] = apply(@act[i], @data[i])
      @act[i] = @act_e
    end
  end
  def operate(x, y)
  end
  def apply(m, x)
  end
  def composition(m, n) # left M-act
  end
end
