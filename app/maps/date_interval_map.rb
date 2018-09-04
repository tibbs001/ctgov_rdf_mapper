module DateIntervalMap
  include RdfPrefixes

  extend self

  def uri(namespace,date_interval)
    "#{namespace}dateInterval#{uid(date_interval)}"
  end

  def types(date_interval)
    [core("DateTimeInterval")]
  end
  
  def inferred_types(d)
    [owl("Thing")]
  end

  def properties(date_interval)
    map ={
      core("start") => (date_interval.start_date_value if date_interval.start_date)
    }
    map.merge!(core("end") => date_interval.end_date_value) if date_interval.end_date
    map
  end

  def uid(date_interval)
    start_uid = date_interval.start_date ? '-s' + date_interval.start_date.strftime('%Y%m%d') : nil
    end_uid   = date_interval.end_date ?  '-e' + date_interval.end_date.strftime('%Y%m%d') : nil
    [start_uid,end_uid].compact.join
  end

end
