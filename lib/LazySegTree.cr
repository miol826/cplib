class LazySegmentTree(T_X, T_M)
  @n : Int32
  @log : Int32
  @n0 : Int32
  @data : Array(T_X)
  @act : Array(T_M)

  def initialize(ary : Array(T_X), @e : T_X, @act_e : T_M)
    @n = ary.size
    @log = (@n - 1).bit_length
    @n0 = 1 << @log
    @data = Array(T_X).new(2 * @n0 - 1, @e)
    @act = Array(T_M).new(2 * @n0 - 1, @act_e)
    ary.each_with_index do |i, j|
      @data[j + @n0 - 1] = i
    end
    (@n0 - 2).downto(0) do |i|
      @data[i] = operate(@data[2 * i + 1], @data[2 * i + 2])
    end
  end

  def initialize(@n : Int32, @e : T_X, @act_e : T_M)
    @log = (@n - 1).bit_length
    @n0 = 1 << @log
    @data = Array(T_X).new(2 * @n0 - 1, @e)
    @act = Array(T_M).new(2 * @n0 - 1, @act_e)
  end

  def update(l : Int32, r : Int32, m : T_M)
    push_all l, r
    lidx = l + @n0 - 1
    ridx = r + @n0 - 1
    while lidx < ridx
      if lidx & 1 == 0
        push lidx
        @act[lidx] = m
        push lidx
      end
      if ridx & 1 == 0
        push(ridx - 1)
        @act[ridx - 1] = m
        push(ridx - 1)
      end
      lidx >>= 1
      ridx = (ridx - 1) >> 1
    end
    lidx = l + @n0 - 1
    ridx = r + @n0 - 2
    while lidx > 0
      lidx = (lidx - 1) >> 1
      ridx = (ridx - 1) >> 1
      push((lidx << 1) + 1)
      push((lidx << 1) + 2)
      @data[lidx] = operate @data[(lidx << 1) + 1], @data[(lidx << 1) + 2]
      push((ridx << 1) + 1)
      push((ridx << 1) + 2)
      @data[ridx] = operate @data[(ridx << 1) + 1], @data[(ridx << 1) + 2]
    end
  end
  def find(l : Int32, r : Int32)
    push_all l, r
    l += @n0 - 1
    r += @n0 - 1
    res1 = @e
    res2 = @e
    while l < r
      push l
      push r - 1
      res1 = operate res1, @data[l] if l & 1 == 0
      res2 = operate @data[r - 1], res2 if r & 1 == 0
      l >>= 1
      r = (r - 1) >> 1
    end
    operate res1, res2
  end

  def []=(i : Int32, x : T_X)
    push_all(i, i + 1)
    i += @n0 - 1
    @data[i] = x
    @act[i] = @act_e
    while i > 0
      i = (i - 1) >> 1
      push((i << 1) + 1)
      push((i << 1) + 2)
      @data[i] = operate((i << 1) + 1, (i << 1) + 2)
    end
  end

  private def push_all(l : Int32, r : Int32)
    lidx = l + @n0
    ridx = r + @n0 - 1
    @log.downto(0) do |i|
      push((lidx >> i) - 1)
      push((ridx >> i) - 1)
    end
  end
  private def push(i : Int32)
    if @act[i] != @act_e
      if i < @n0 - 1
        @act[(i << 1) + 1] = composition(@act[i], @act[(i << 1) + 1])
        @act[(i << 1) + 2] = composition(@act[i], @act[(i << 1) + 2])
      end
      @data[i] = apply(@act[i], @data[i])
      @act[i] = @act_e
    end
  end

  private def operate(x : T_X, y : T_X)
  end
  private def apply(m : T_M, x : T_X)
  end
  private def composition(m : T_M, n : T_M)
  end
end
