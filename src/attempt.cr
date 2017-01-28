require "calling"
require "./version"
require "./lib/*"

struct Attempt
  FOREVER = -1_i64

  getter times : Int64?
  getter wait : Float64?
  getter prewait : Float64?

  def initialize(
    times : Int::Primitive? = nil,
    wait : Number? = nil,
    prewait : Number? = nil
  )
    self.times = times
    self.wait = wait
    self.prewait = prewait
  end

  def times=(n : Int::Primitive?)
    @times = if n
      n.to_i64
    end
  end

  def wait=(seconds : Number?)
    @wait = if seconds
      seconds.to_f64
    end
  end

  def prewait=(seconds : Number?)
    @prewait = if seconds
      seconds.to_f64
    end
  end

  def dup
    self.class.new(times: @times, wait: @wait, prewait: @prewait)
  end

  def times(n : Int::Primitive)
    o = dup
    o.times = n
    o
  end

  def wait(seconds : Number)
    o = dup
    o.wait = seconds
    o
  end

  def prewait(seconds : Number)
    o = dup
    o.prewait = seconds
    o
  end

  def self.times(value : Int::Primitive)
    new(times: value)
  end

  def self.wait(value : Number)
    new(wait: value)
  end

  def self.prewait(value : Number)
    new(prewait: value)
  end

  def start
    Attempt::Context.new(self).attempt do
      yield
    end
  end

  def self.start
    Attempt.new.start do
      yield
    end
  end

  def new_context
    Attempt::Context.new(self)
  end
end
