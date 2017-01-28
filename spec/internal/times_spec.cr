require "../spec_helper"

class AttemptInternalSpecs::Times
  getter attempts = 0

  def stable
    @attempts += 1
    "stable"
  end

  def unstable
    @attempts += 1
    raise Exception.new
  end

  describe name do
    it "stable" do
      actual = Times.new

      result = Attempt.times(5).start do
        begin
          break actual.stable
        rescue
        end
      end

      actual.attempts.should eq 1
      result.should eq "stable"
    end

    it "unstable" do
      actual = Times.new

      result = Attempt.times(5).start do
        begin
          break actual.unstable
        rescue
        end
      end

      actual.attempts.should eq 5
      result.should be_nil
    end
  end
end
