class WeightedUnionFind
  def initialize(n)
    @par = Array.new(n) {_1}
    @potential = [0] * n
  end
  def root(x)
    return x if @par[x] == x
    r = root @par[x]
    @potential[x] += @potential[@par[x]]
    @par[x] = r
  end
  def same?(x, y)
    root(x) == root(y)
  end
  def unite(x, y, w)
    unless same?(x, y)
      w += @potential[x] - @potential[y]
      x, y = root(x), root(y)
      @potential[y] = w
      @par[y] = x
    end
  end
  def diff(x, y)
    same?(x, y) ? @potential[y] - @potential[x] : nil
  end
end
