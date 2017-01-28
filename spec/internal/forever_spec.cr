require "../spec_helper"

class AttemptInternalSpecs::Forever
  include AttemptSpecHelper

  getter attempts = 0

  def fail
    return if @attempts == 100
    @attempts += 1
    raise Exception.new
  end

  describe name do
    it "explicit" do
      clean
      actual = Forever.new

      result = Attempt.times(Attempt::FOREVER).start do
        begin
          break actual.fail
        rescue
        end
      end

      actual.attempts.should eq 100
    end

    it "implicit" do
      clean
      actual = Forever.new

      result = Attempt.start do
        begin
          break actual.fail
        rescue
        end
      end

      actual.attempts.should eq 100
    end
  end
end
