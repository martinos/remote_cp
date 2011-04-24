def rt_cat
  @clipboard ||= RemoteCp::Clipboard.new
  @clipboard.pull
end
  
def rt_cp
  @clipboard ||= RemoteCp::Clipboard.new
  @clipboard.push(self)
end
