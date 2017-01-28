require "spec"
require "stdio"
require "../src/attempt"

module AttemptSpecHelper
  macro included
    extend ::AttemptSpecHelper
  end

  def clean
    Attempt.sleep(Calling::Any).clear
  end
end
