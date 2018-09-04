class Institution

  def self.from_file(filename)
    institutions = []
    rows = FasterCSV.read(filename, :headers => true)
    rows.each do |row|
      params = {
       :uid   => row[0],
       :label => row[1],
       :type  => row[2]
      }
      institutions << VivoMapper::Institution.new(params)
    end
    return institutions
  end

end
