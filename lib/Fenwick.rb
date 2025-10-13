class FenwickTree
  def initialize(n)
    @n = n + 1
    @data = Array.new(@n, 0)
  end
  def add(idx, x)
    idx += 1
    while idx < @n do
      @data[idx] += x
      idx += idx & -idx
    end
  end
  def sum(idx)
    idx += 1
    res = 0
    while idx > 0 do
      res += @data[idx]
      idx -= idx & -idx
    end
    res
  end
end
