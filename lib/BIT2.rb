class BIT2
  def initialize(n)
    @bit0 = FenwickTree.new(n)
    @bit1 = FenwickTree.new(n)
  end
  def add(l, r, x)
    @bit0.add(l, -x * (l - 1))
    @bit0.add(r, x * (r - 1))
    @bit1.add(l, x)
    @bit1.add(r, -x)
  end
  def sum(idx)
    @bit0.sum(idx) + @bit1.sum(idx) * idx
  end
end
