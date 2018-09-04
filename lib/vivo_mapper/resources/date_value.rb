module VivoMapper
  class DateValue < Resource
    attr_reader :date, :precision

    def initialize(date,precision)
      @date, @precision = date, precision
      super()
    end

  end
end
