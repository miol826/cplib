class RollingHashMaster
  def initialize
    @mod = (1 << 61) - 1
    @base = rand(30..1 << 60)
  end
end
class RollingHash < RollingHashMaster
end
