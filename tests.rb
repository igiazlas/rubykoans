#!/usr/bin/env ruby

class Television
  attr_accessor :channel

  def power
    if @power == :on
      @power = :off
    else
      @power = :on
    end
  end

  def on?
    @power == :on
  end
end

class Proxy
  attr_reader :messages

  def initialize(target_object)
    @object = target_object
    # ADD MORE CODE HERE
    @messages = Array.new
  end

  # WRITE CODE HERE
  def method_missing(method_name, *args, &block)
    @messages << method_name.to_sym
    if args.length > 0
      eval("@object.__send__(:#{method_name}, #{args.join(", ")})")
    else
      @object.__send__(method_name)
    end
  end

  def called?(method_name)
    @messages.include?(method_name)
  end

  def number_of_times_called(method_name)
    (@messages.find_all { |name| name == method_name }).count
  end
end

p_tv = Proxy.new(Television.new)
p_tv.channel = 10
p_tv.power
p_tv.power
p_tv.power

puts p_tv.called?(:power)

puts p_tv.number_of_times_called(:power)

