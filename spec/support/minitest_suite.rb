module MiniTestSuite

  class Unit < Turn::MiniRunner #MiniTest::Unit

    @before_all = nil, @after_all = nil
    
    def before_all(&block)
      @before_all = block
    end    

    def after_all(&block)
      @after_all = block
    end    

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end

    def _run_suite(suite, type)
      begin
        suite.before_suite if suite.respond_to?(:before_suite)
        super(suite, type)
      ensure
        suite.after_suite if suite.respond_to?(:after_suite)
      end
    end

    #custom before all suit hook
    def before_suites
      @before_all.call unless @before_all.nil?
    end

    #custom after all suit hook
    def after_suites
      @after_all.call unless @after_all.nil?
    end
  end
end
