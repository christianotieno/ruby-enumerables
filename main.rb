# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    entry = is_a?(Range) ? to_a : self
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    entry
  end

  def my_each_with_index
    return to_enum unless block_given?

    entry = is_a?(Range) ? to_a : self

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
    entry
  end

  def my_select
    return to_enum unless block_given?

    i = 0
    arr = []
    while i < size
      arr << self[i] if yield(self[i])
      i += 1
    end
    arr
  end

  def my_all?
    if block_given?
      x = true
      my_each { |e| x = false unless yield(e) }
      x
    end
    my_each { |e| return false unless check_validity(e, arg) }
    true
  end

  def my_any?(arg = nil, &proc)
    if block_given?
      my_each { |e| return true if proc.nil? ? proc.call(e) : yield(e) }
    else
      my_each { |e| return true if arg.nil? ? elem : check_validity(e, arg) }
    end
    false
  end

  def my_none?
    x = true
    my_each { |e| x = false if yield(e) }
    x
  end

  def my_count
    total = 0
    my_each { total += 1 }
    total
  end

  def my_map
    (my_map_proc = nil)
    x = []
    if my_map_proc.nil?
      my_each { |e| x << yield(e) }
    else
      my_each { |e| x << (my_map_proc.call e) }
    end
    x
  end

  def my_inject(val)
    my_each { |e| val = yield(val, e) }
    val
  end

  def multiply_els(array)
    array.my_inject(1) { |x, y| x * y }
  end

  def check_validity(elem, param)
    return elem.is_a?(param) if param.is_a?(Class)

    if param.is_a?(Regexp)
      return false if elem.is_a?(Numeric)

      return param.match(entry)
    end
    (elem == param)
  end
end
