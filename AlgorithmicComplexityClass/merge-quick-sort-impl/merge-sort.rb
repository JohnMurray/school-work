

# We're opening up the Array class so that we can call our sorting
# algorithms like:
#
#   a = [9, 8, 7, 2, 3, 4, 6, 1, 11, 58, 7009]
#   a.merge_sort
class Array


  # Public: Perform a merge sort based on some predicate. The predicate
  # for merge_sort is similar to predicates used in other built-in Ruby
  # sorting algorithms.
  #
  # pred - Sorting predicate using the 'rocket' operator
  #
  # Examples
  #
  #   a = [9, 1, 8, 2, 7, 3]
  #   a.merge_sort                      #=> [1, 2, 3, 7, 8, 9]
  #   a.merge_sort {|a,b| a <=> b}      #=> [1, 2, 3, 7, 8, 9]
  #   a.merge_sort {|a,b| b <=> a}      #=> [9, 8, 7, 3, 2, 1]
  #
  # Returns a copy of the array, sorted
  def merge_sort(&pred)
    pred ||= lambda {|a,b| a <=> b}

    return self.dup if count <= 1
    halves = split.map {|h| h.merge_sort(&pred) }
    merge(*halves, &pred)
  end

  private

  # Private: Split the array into two equal halves (if possible).
  # If the array is of an odd length, then the left-hand side
  # returned will always have one more element.
  #
  # Returns an array containing the first-half and second half of the
  # original array (eg. [[1, 2], [3, 4]])
  def split
    return [self, []] if count == 1
    middle = ((count - 1) / 2.0).floor
    [self[0..middle], self[(middle+1)..-1]]
  end

  # Private: Using the provided sorting-predicate, merge the left-hand and
  # right-hand sides of the [sub-]array.
  #
  # lh   - Left-Hand side of the array being merged
  # rh   - Right-Hand side of the array being merged
  # pred - Sorting predicate using the 'rocket' operator
  # 
  # Examples
  #
  #   merge([1,4], [2,3], {|a,b| a <=> b})        #=> [1, 2, 3, 4]
  #   merge([1,4], [2,3], {|a,b| b <=> a})        #=> [4, 3, 2, 1]
  #   merge([], [1, 2], {|a,b| a <=> b})          #=> [1, 2]
  #   merge([1, 2], [], {|a,b| a <=> b})          #=> [1, 2]
  #   
  # Returns a single, sorted Array
  def merge(lh, rh, &pred)
    return lh.dup if rh.empty?
    return rh.dup if lh.empty?

    sorted = []
    until lh.empty? || rh.empty?
      order = pred.call(lh.first, rh.first)
      case order
      when -1, 0; sorted << lh.shift
      when 1;     sorted << rh.shift
      end
    end

    sorted + lh + rh
  end

end
