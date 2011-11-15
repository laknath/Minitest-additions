module MiniTest::Assertions

  def assert_dom_equal(expected, actual, message = nil)
    expected_dom = HTML::Document.new(expected).root
    actual_dom   = HTML::Document.new(actual).root
    message      = "expected:\n #{actual}\nto equal:\n#{expected}"
    assert_block(message) { expected_dom == actual_dom }
  end

  #any additional assertion can go here ...

end
