struct Attempt
  class Context
    @attempts = 0_i64
    @times : Int64
    @wait : Float64
    @prewait : Float64

    def initialize(@attempt : Attempt)
      @times = @attempt.times || Attempt::FOREVER
      @wait = @attempt.wait || 0_f64
      @prewait = @attempt.prewait || 0_f64
    end

    def attempt
      loop do
        break unless attempts?
        wait
        yield
        @attempts += 1
      end
    end

    def attempt_once
      return unless attempts?
      wait
      yield
      @attempts += 1
    end

    def wait
      if @attempts == 0
        Attempt.sleep @prewait if @prewait > 0
        return
      end
      Attempt.sleep @wait if @wait > 0
    end

    def attempts?
      return true if @times == -1
      return true if @attempts < @times
      false
    end
  end
end
