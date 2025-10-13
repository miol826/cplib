class FenwickTree(T)
  @n : Int32
  @data : Array(T)
  def initialize(n : Int32)
    @n = n + 1
    @data = Array.new(@n) {T.new(0)}
  end
  def add(idx : Int32, x : T)
    idx += 1
    while idx < @n
      @data[idx] += x
      idx += idx & -idx
    end
  end
  def sum(idx : Int32)
    idx += 1
    res = T.new(0)
    while idx > 0
      res += @data[idx]
      idx -= idx & -idx
    end
    res
  end
  def find_min(x : T)
    return nil if sum(@n - 2) < x
    i = l = 1
    while (l << 1) < @n
      l <<= 1
    end
    while l > 0
      if i + l - 1 < @n && @data[i + l - 1] < x
        x -= @data[i + l - 1]
        i += l
      end
      l >>= 1
    end
    i - 1
  end
end
