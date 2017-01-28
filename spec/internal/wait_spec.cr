require "../spec_helper"

class AttemptInternalSpecs::Wait
  include AttemptSpecHelper

  WAIT = 0.1_f64
  getter attempts = 0

  def succeed
    @attempts += 1
    "succeeded"
  end

  def fail
    @attempts += 1
    raise Exception.new
  end

  describe name do
    it "does not wait" do
      clean
      actual = Wait.new

      result = Attempt.times(5).wait(1).start do
        begin
          break actual.succeed
        rescue
        end
      end

      actual.attempts.should eq 1
      Attempt.sleep(Calling::Any).size.should eq 0
      result.should eq "succeeded"
    end

    it "waits" do
      clean
      actual = Wait.new

      result = Attempt.times(5).wait(WAIT).start do
        begin
          break actual.fail
        rescue
        end
      end

      actual.attempts.should eq 5
      {% if flag?(:retry_test) %}
        Attempt.sleep(Calling::Any).should eq [
          {args: {seconds: WAIT}},
          {args: {seconds: WAIT}},
          {args: {seconds: WAIT}},
          {args: {seconds: WAIT}}
        ]
      {% end %}
      result.should be_nil
    end
  end
end
