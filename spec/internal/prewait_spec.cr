require "../spec_helper"

class AttemptInternalSpecs::Prewait
  include AttemptSpecHelper

  PREWAIT = 0.05_f64
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

      result = Attempt.times(5).wait(WAIT).prewait(PREWAIT).start do
        begin
          break actual.succeed
        rescue
        end
      end

      actual.attempts.should eq 1
      {% if flag?(:attempt_test) %}
        Attempt.sleep(Calling::Any).should eq [
          {args: {seconds: PREWAIT}}
        ]
      {% end %}
      result.should eq "succeeded"
    end

    it "waits" do
      clean
      actual = Wait.new

      result = Attempt.times(5).wait(WAIT).prewait(PREWAIT).start do
        begin
          break actual.fail
        rescue
        end
      end

      actual.attempts.should eq 5
      {% if flag?(:attempt_test) %}
        Attempt.sleep(Calling::Any).should eq [
          {args: {seconds: PREWAIT}},
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
