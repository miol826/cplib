class DualSegmentTree(T)
  @n : Int32
  @log : Int32
  @n0 : Int32
  @act : Array(T)

  def initialize(@n : Int32, @act_e : T)
    @log = (@n - 1).bit_length
    @n0 = 1 << @log
    @act = Array(T).new(2 * @n0 - 1, @act_e)
  end

  def update(l : Int32, r : Int32, m : T)
    lidx = l + @n0 - 1
    ridx = r + @n0 - 1
    while lidx < ridx
      @act[lidx] = composition m, @act[lidx] if lidx & 1 == 0
      @act[ridx - 1] = composition m, @act[ridx - 1] if ridx & 1 == 0
      lidx >>= 1
      ridx = (ridx - 1) >> 1
    end
  end

  def [](i : Int32)
    i += @n0 - 1
    res = @act[i]
    while i > 0
      res = composition @act[i = (i - 1) >> 1], res
    end
    res
  end

  private def composition(m : T, n : T)
    m + n
  end
end
