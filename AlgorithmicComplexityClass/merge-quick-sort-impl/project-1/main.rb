require './merge-sort'
require './quick-sort'


# Time any block of code
def time
  t1 = Time.now
  yield
  t2 = Time.now
  diff = t2 - t1

  # return time in milliseconds
  diff * 1000
end


# Generates random numbers between 1 and 10,000
def gen_random(power_of_2)
  randoms = []
  1.upto(2**power_of_2) do
    randoms << rand(10_000)
  end
  randoms
end



# The main runner for the program. Runs the sorts over various
# input sizes and collects the timed results.
def main
  print 'running '

  avgs = {}
  500.times do
    [4, 6, 8, 10, 14, 16].each do |power|
      avgs[power] ||= Hash.new {|h,k| h[k] = []}

      unsorted_array = gen_random(power)

      ms_array   = unsorted_array.dup
      qs_array_1 =  unsorted_array.dup
      qs_array_2 =  unsorted_array.dup

      avgs[power][:mst]  << time { ms_array.merge_sort }
      avgs[power][:qst1] << time { qs_array_1.quick_sort! :pivot => :first }
      avgs[power][:qst2] << time { qs_array_2.quick_sort! :pivot => :last }
    end
    print '.'
  end
  
  record avgs
end



def record(avgs)
  avgs.each do |power, avg|
    puts
    puts "Input Size: 2^#{power}:"
    puts "Average Time (ms):"
    puts "\tmerge-sort:                      #{avg[:mst].inject(:+)/avg[:mst].size}"
    puts "\tquick-sort(first-element pivot): #{avg[:qst1].inject(:+)/avg[:qst1].size}"
    puts "\tquick-sort(last-element pivot):  #{avg[:qst2].inject(:+)/avg[:qst2].size}"
    puts
  end
end


main if $0 == __FILE__
