module VivoMapper
  class DateInterval < Resource
    attr_reader :start_date, :end_date, :precision

    def initialize(start_date, end_date, precision)
      @start_date, @end_date, @precision = start_date, end_date, precision
      super()
    end

    def start_date_value
      DateValue.new(start_date,precision)
    end

    def end_date_value
      DateValue.new(end_date,precision)
    end
  end
end
