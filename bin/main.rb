#!/usr/bin/env ruby

# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

# rubocop:disable Metrics/CyclomaticComplexity

# rubocop:disable Metrics/ModuleLength

require 'minitest/pride'

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

  def my_all?(pattern = nil)
    outcome = true
    if block_given?
      my_each { |x| outcome &= (yield x) }
    elsif pattern
      my_each { |x| outcome &= pattern === x }
    else
      my_each { |x| outcome &= x }
    end
    outcome
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |x| return true if yield x }
    elsif pattern
      my_each { |x| return true if pattern === x }
    else
      my_each { |x| return true if x }
    end
    false
  end    

  def my_none?(pattern = nil, &a_block)
    !my_any?(pattern, &a_block)
  end

  def my_count(xander = nil)
    count = 0
    if block_given?
      my_each { |e| count += 1 if yield e }
    elsif xander
      my_each { |e| count += 1 if e == xander }
    else
      count = length
    end
    count
  end

  def my_map
    return to_enum :my_map unless block_given?

    i = 0
    arr = []

    while i < size
      arr << if block_given?
                  yield(self[i])
                else
                  proc.call(self[i])
                end
      i += 1
    end
    arr
  end

  def my_inject(*args)
    arr = to_a
    case args.length
    when 0
      output = arr[0]
      arr.my_each_with_index { |x, i| output = yield(output, x) unless i.zero? }
    when 1
      if args[0].is_a? Integer
        output = args[0]
        arr.my_each { |x| output = yield(output, x) }
        return output
      end
      output = arr[0]
      action = args[0]
      arr.my_each_with_index { |x, i| output = output.method(action).call(x) unless i.zero? }
    when 2
      output = args[0]
      action = args[1]
      arr.my_each { |x| output = output.method(action).call(x) }
    end
    output
  end
    
  def multiply_els
    result = 1
    my_each { |element| result *= element }
    result
  end

  def check_validity(entry, param)
    if entry.is_a? Regexp
      !entry.to_s.match(param).nil?
    elsif param.is_a? Class
      (entry.class == param)
    else
      (entry == param)
    end
  end
end

