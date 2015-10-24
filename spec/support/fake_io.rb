require 'forwardable'

class FakeIO
  extend Forwardable

  def_delegators :@items, :to_s, :include?, :length
  def initialize
    @items = []
  end

  def puts(*args)
    @items.push(*args)
  end

  def print(*args)
    @items.push(*args)
  end
end
