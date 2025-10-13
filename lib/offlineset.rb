class IntSet20
  attr_reader :size
  def initialize
    @d1 = 0
    @d2 = Array.new(32, 0)
    @d3 = Array.new(1024, 0)
    @d4 = Array.new(32768, 0)
    @size = 0
  end
  def insert(x)
    return nil if include_p(x)
    @d1 |= 1 << (x >> 15)
    @d2[x >> 15] |= 1 << (x >> 10 & 31)
    @d3[x >> 10] |= 1 << (x >> 5 & 31)
    @d4[x >> 5] |= 1 << (x & 31)
    @size += 1
  end
  alias << insert
  def delete(x)
    return nil unless include_p(x)
    @d4[x >> 5] ^= 1 << (x & 31)
    @d3[x >> 10] ^= 1 << (x >> 5 & 31) if @d4[x >> 5] == 0
    @d2[x >> 15] ^= 1 << (x >> 10 & 31) if @d3[x >> 10] == 0
    @d1 ^= 1 << (x >> 15) if @d2[x >> 15] == 0
    @size -= 1
  end
  def include?(x)
    @d1[x >> 15] & @d2[x >> 15][x >> 10 & 31] & @d3[x >> 10][x >> 5 & 31] & @d4[x >> 5][x & 31] == 1
  end
  def empty?
    @d1 == 0
  end
  def min
    return nil if empty?
    res = (@d1 & -@d1).bit_length - 1
    res = res << 5 | (@d2[res] & -@d2[res]).bit_length - 1
    res = res << 5 | (@d3[res] & -@d3[res]).bit_length - 1
    res << 5 | (@d4[res] & -@d4[res]).bit_length - 1
  end
  def max
    return nil if empty?
    res = @d1.bit_length - 1
    res = res << 5 | @d2[res].bit_length - 1
    res = res << 5 | @d3[res].bit_length - 1
    res << 5 | @d4[res].bit_length - 1
  end
  def lower_bound(x)
    return min_p if x < 0
    return nil if empty? || max_p < x
    res = @d4[x >> 5] & ~((1 << (x & 31)) - 1)
    return x & 1048544 | (res & -res).bit_length - 1 if res > 0
    res = @d3[x >> 10] & ~((1 << 1 + (x >> 5 & 31)) - 1)
    if res > 0 then
      res = x & 1047552 | ((res & -res).bit_length - 1) << 5
      return res | (@d4[res >> 5] & -@d4[res >> 5]).bit_length - 1
    end
    res = @d2[x >> 15] & ~((1 << 1 + (x >> 10 & 31)) - 1)
    if res > 0 then
      res = x & 1015808 | ((res & -res).bit_length - 1) << 10
      res |= (@d3[res >> 10] & -@d3[res >> 10]).bit_length - 1 << 5
      return res | (@d4[res >> 5] & -@d4[res >> 5]).bit_length - 1
    end
    res = @d1 & ~((1 << 1 + (x >> 15 & 31)) - 1)
    res = (res & -res).bit_length - 1 << 15
    res |= (@d2[res >> 15] & -@d2[res >> 15]).bit_length - 1 << 10
    res |= (@d3[res >> 10] & -@d3[res >> 10]).bit_length - 1 << 5
    return res | (@d4[res >> 5] & -@d4[res >> 5]).bit_length - 1
  end
  private
  def include_p(x)
    @d1[x >> 15] & @d2[x >> 15][x >> 10 & 31] & @d3[x >> 10][x >> 5 & 31] & @d4[x >> 5][x & 31] == 1
  end
  def min_p
    return nil if empty?
    res = (@d1 & -@d1).bit_length - 1
    res = res << 5 | (@d2[res] & -@d2[res]).bit_length - 1
    res = res << 5 | (@d3[res] & -@d3[res]).bit_length - 1
    res << 5 | (@d4[res] & -@d4[res]).bit_length - 1
  end
  def max_p
    return nil if empty?
    res = @d1.bit_length - 1
    res = res << 5 | @d2[res].bit_length - 1
    res = res << 5 | @d3[res].bit_length - 1
    res << 5 | @d4[res].bit_length - 1
  end
end

class OfflineSet < IntSet20
  def initialize(arr)
    @arr = arr.sort.uniq
    @ha = @arr.each_with_index.to_h
    super()
  end
  def insert(x)
    idx = @ha[x]
    raise RuntimeError, 'unexpected argument' if idx.nil?
    super(idx)
  end
  alias << insert
  def delete(x)
    idx = @ha[x]
    return nil if idx.nil?
    super(idx)
  end
  def include?(x)
    idx = @ha[x]
    return false if idx.nil?
    super(idx)
  end
  def min
    r = super
    r.nil? ? nil : @arr[r]
  end
  def max
    r = super
    r.nil? ? nil : @arr[r]
  end
  def lower_bound(x)
    idx = @ha[x] || @arr.bsearch_index {|i| i >= x}
    return nil if idx.nil?
    r = super(idx)
    r.nil? ? nil : @arr[r]
  end
end
