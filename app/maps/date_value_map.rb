module DateValueMap
  include RdfPrefixes

  extend self

  def uri(namespace,date_value)
    "#{namespace}dateValue#{uid(date_value)}"
  end

  def types(date_value)
    [core("DateTimeValue")]
  end

  def inferred_types(d)
    [owl("Thing")]
  end

  def properties(date_value)
    {
      core("dateTime") => date_value.date,
      core("dateTimePrecision") => core("#{date_value.precision}Precision")
    }
  end

  def uid(date_value)
    if d = date_value.date
      d.strftime('%Y%m%d')
    end
  end

end
