class FakeIO
  def initialize
    @items = []
  end

  def puts(*args)
    @items.push(*args)
  end

  def print(*args)
    @items.push(*args)
  end

  def method_missing(method_sym, *arguments, &block)
    @items.send(method_sym, *arguments)
  end
end
