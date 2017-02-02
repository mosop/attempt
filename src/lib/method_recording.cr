struct Attempt
  {% if flag?(:attempt_test) %}
    extend Calling::Rec
  {% else %}
    extend Calling::NoRec
  {% end %}

  record_method :sleep, :any, {seconds: Float64} do
    ::sleep seconds
  end
end
