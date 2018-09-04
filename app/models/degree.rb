class Degree

  def self.from_file(filename)
    degrees = []
    rows = FasterCSV.read(filename, :headers => true)
    rows.each do |row|
      params = {
       :uid                 => row[0],
       :label               => row[1],
       :degree_abbreviation => row[2]
      }
      degrees << VivoMapper::Degree.new(params)
    end
    return degrees
  end

end
