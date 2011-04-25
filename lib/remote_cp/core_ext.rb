def rt_cat
  @clipboard ||= RemoteCp::Clipboard.new
  @clipboard.pull
end
  
def rt_cp(str)
  @clipboard ||= RemoteCp::Clipboard.new
  @clipboard.push(str)
end
