module HostProperties
  def allocated_memory
    mem_total = node.memory['total'][/\d*/].to_i
    mem_factor = node['elasticsearch']['heap_mem_percent'].to_f / 100
    max_allocated_memory = node['elasticsearch']['max_allocated_memory']
    "#{([(mem_total * mem_factor).floor, max_allocated_memory].min / 1024)}m"
  end

  def bulk_size
    num_cpu = node['cpu']['total'].to_i
    num_cpu -= 1 if num_cpu > 2
    num_cpu
  end
end
