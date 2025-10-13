class MinSegtree
  def initialize(n)
    @n=2**Math.log(n,2).ceil
    @e=2**31-1
    @data=Array.new(2*@n-1,@e)
  end
  def update(i,x)
    i+=@n-1
    @data[i]=x
    while i>0 do
      i=(i-1)/2
      @data[i]=[@data[i*2+1],@data[i*2+2]].min
    end
  end
  def find(a,b,i=0,l=0,r=@n)
    if r<=a || b<=l then
      return @e
    elsif a<=l && r<=b then
      return @data[i]
    else
      return [find(a,b,i*2+1,l,(l+r)/2),find(a,b,i*2+2,(l+r)/2,r)].min
    end
  end
end
