class MinHeap
  def initialize
    @data=Array.new
  end
  def size
    @data.size
  end
  def empty?
    @data.size==0
  end
  def insert(x)
    idx=@data.size
    @data << x
    while idx>0 && @data[(idx-1)/2]>@data[idx] do
      @data[(idx-1)/2],@data[idx]=@data[idx],@data[(idx-1)/2]
      idx=(idx-1)/2
    end
  end
  def << (x)
    insert(x)
  end
  def pop
    return nil if @data.size==0
    return @data.pop if @data.size==1
    r=@data[0].dup
    @data[0]=@data.pop
    idx=0
    while 2*idx+1<@data.size do
      n_idx=2*idx+1
      n_idx+=1 if n_idx+1 < @data.size && @data[n_idx+1]<@data[n_idx]
      break if @data[idx]<@data[n_idx]
      @data[idx],@data[n_idx]=@data[n_idx],@data[idx]
      idx=n_idx
    end
    r
  end
end
