module MiniTest::Assertions

  def assert_validate_with_message(expected, message = nil)
    caught = false
    begin
      yield
    rescue ActiveRecord::RecordInvalid => e
      caught = true
      assert e.record.errors.full_messages.include?(expected)
    rescue Exception => e
      caught = true
      refute true, "expected: ActiveRecord::RecordInvalid but threw a \n#{e.class} \n with message #{e.message}"
    ensure
      if !caught
        refute true, "expected: ActiveRecord::RecordInvalid but threw nothing."
      end
    end
  end

  #any additional assertion can go here ...
end
