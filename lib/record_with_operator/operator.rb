module RecordWithOperator
  module Operator
    def operator=(o)
      Thread.current[:operator] = o
    end

    def operator
      Thread.current[:operator]
    end
  end
end
