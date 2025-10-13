class UnionFind
  def initialize(n)
    @par = Array.new(n) {|i| i}
    @size = Array.new(n, 1)
  end
  def find(x)
    return x if @par[x] == x
    @par[x] = find(@par[x])
  end
  def same?(x, y)
    find(x) == find(y)
  end
  def union(x, y)
    return if same? x, y
    x, y = y, x if @size[find x] < @size[find y]
    @size[find x] += @size[find y]
    @par[find y] = find x
  end
  def size(x)
    @size[find x]
  end
end
