
# We're opening up the Array class so that we can call our sorting
# algorithms like:
#
#   a = [9, 8, 7, 2, 3, 4, 6, 1, 11, 58, 7009]
#   a.quick_sort!
class Array
  
  # Public: Perform a quick-sort on the Array. Note that this does perform
  # an in-place changing of the array (thus the bang[!]) in the method-
  # signature is used to denote a dangerous action.
  #
  # opts - Options for quick_sort. Currently the only option that is valid is
  #        :pivot which can either be :first or :last and specifies the index
  #        of the pivot to be used in the sort.
  # pred - Sorting predicate using the 'rocket' operator
  #
  # Examples
  #
  #   a = [9, 1, 8, 2, 7, 3]
  #   a.quick_sort!                     #=> [1, 2, 3, 7, 8, 9]
  #   a.quick_sort! :pivot => :last     #=> [1, 2, 3, 7, 8, 9]
  #   a.quick_sort! :pivot => :first    #=> [1, 2, 3, 7, 8, 9]
  #   a.quick_sort! {|a,b| b <=> a}     #=> [9, 8, 7, 3, 2, 1]
  #
  # Returns an instance of 'self' (the Array), but sorted
  def quick_sort!(opts = {}, &pred)
    opts[:pivot] ||= :first
    pred         ||= lambda {|a,b| a <=> b}

    quick_sort_recursive(0, count - 1, opts[:pivot], pred)
    self
  end

  private

  # Private: the actual quick-sort algorithm that calls itself recursively.
  #
  # p               - Starting index for portion of array in which to sort
  # r               - Ending index for position of array in which to sort
  # pivot_selection - Option from 'quick_sort!' method which is 'proxied' to
  #                   the 'partition' method.
  # pred            - Option from 'quick_sort!' method which is 'proxied' to
  #                   the 'partition' method.
  #
  # Returns nothing (since self is modified in place)
  def quick_sort_recursive(p, r, pivot_selection, pred)
    if p < r
      q = partition(p, r, pivot_selection, pred)
      quick_sort_recursive(p, q - 1, pivot_selection, pred)
      quick_sort_recursive(q + 1, r, pivot_selection, pred)
    end
  end


  # Private: Partition the array into two sections based on a pivot value and
  # a sorting predicate, such that the pivot is in the middle of all values.
  # p               - Starting index for portion of array in which to sort
  # r               - Ending index for position of array in which to sort
  # pivot_selection - Either :first or :last/anything-really. This determines
  #                   whether the pivot used is the first or last element in the
  #                   [sub-]array.
  # pred            - Sorting predicate using the 'rocket' operator
  #
  # Returns the index for the pivot
  def partition(p, r, pivot_selection, pred)
    # get the pivot index (qi) and the pivot value (q)
    qi = pred == :first ? p : r
    q  = self[qi]

    i = p - 1
    p.upto(r - 1) do |j|
      if [-1, 0].include? pred.call(self[j], q)
        i += 1
        self[i], self[j] = self[j], self[i]
      end
    end
    i += 1

    self[i], self[qi] = self[qi], self[i]
    i
  end

end
