class LinkedList
  include Enumerable

  def Node
    attr_reader :val,:prv,:nxt
    def initialize(val=nil,prv=nil,nxt=nil)
      @val=val
      @prv=prv
      @nxt=nxt
    end
  end

  attr_reader :size
  def initialize
    @sen=Node.new(nil)
    @sen.prv=@sen.nxt=@sen
    @size=0
  end
  def empty?
    @size==0
  end
  def each
    i=@sen
    until (i=i.nxt)==@sen do
      yield i.val
    end
  end
  def [](n)
    i=@sen
    (n+1).times do
      i=i.nxt
      return nil if i==@sen
    end
    i.val
  end
  def push(x)
    y=Node.new(x,@sen.prv,@sen)
    @sen.prv.nxt=y
    @sen.prv=y
    return self
  end
  alias append push
  alias << push
  def pop
    res=@sen.prv
    @sen.prv=@sen.prv.prv
    @sen.rev.nxt=@sen
    res.val
  end
  def shift
    res=@sen.nxt
    @sen.nxt=@sen.nxt.nxt
    @sen.nxt.prv=@sen
    res.val
  end
  def unshift(x)
    y=Node.new(x,@sen,@sen.nxt)
    @sen.nxt=y
    y.nxt.prv=y
    return self
  end
  def insert_at(idx,val)
   ptr=@sen
   (idx+1).times do
     ptr=ptr.nxt
     return nil if ptr==@sen
   end
   y=Node.new(val,ptr,ptr.nxt)
   ptr.nxt=y
   y.nxt.prv=y
  end
  def delete_at(idx)
    ptr=@sen
    (idx+1).times do
      ptr=ptr.nxt
      return nil if ptr==@sen
    end
    ptr.prv.nxt=ptr.nxt
    ptr.nxt.prv=ptr.prv
  end
end
