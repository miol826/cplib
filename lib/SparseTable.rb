class SparseTable
  def initialize(a)
    @n = a.size
    logn = @n.bit_length
    @table = Array.new(@n) {|i| Array.new(logn)}
    logn.times do |i|
      @n.times do |j|
        if i == 0 then
          @table[j][i] = a[j]
        else
          nj = j + (1 << i - 1)
          @table[j][i] = (nj < @n ? operate(@table[j][i - 1], @table[nj][i - 1]) : @table[j][i - 1])
        end
      end
    end
  end
  def query(l, r) # [l, r)
    logk = (r - l).bit_length - 1
    k = 1 << logk
    operate(@table[l][logk], @table[r - k][logk])
  end
  def bsearch(l, x) # find r s.t. max(l..r) >= x, max(l...r) < x
    i = @table[l].rindex {_1 < x}
    return l if i.nil?
    # r in [l + 2 ^ i, l + 2 ^ (i + 1))
    (l + (1 << i)...[l + (1 << i + 1), @n].min).bsearch {query(l, _1 + 1) >= x}
  end
  private
  def operate(x, y)
    x > y ? x : y
  end
end
