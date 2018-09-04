class User
 
  def self.from_file(filename)
    users = []
    rows = FasterCSV.read(filename, :headers => true)
    rows.each do |row|
      params = {
       :uid                   => row[0],
       :external_auth_id      => row[1],
       :last_name             => row[2],
       :first_name            => row[3],
       :email_address         => row[4],
       :password              => row[5] ?  row[5] : 'vivoPassword',  
       :proxy_editor          => row[6],
       :permission_set        => row[7] ?  row[7] : 'selfeditor',
       :status                => row[8] ?  row[8] : 'ACTIVE',
       :pasword_expires       => row[9] ?  row[9] : '0',
      }  
      users << VivoMapper::User.new(params)
    end
    users
  end

end
