require 'open-uri'
require 'net/http'
require 'net/https'
require 'csv'
ELEMENTS_URL="https://???elements.duke.edu:9999"
NS = "http://www.symplectic.co.uk/publications/api"

class Publication

  def self.retrieve_pubs(duids)
    duids.each do |duid|
      response=''
      url = URI.parse(self.get_pubs_uri_for(duid))
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == 'https'
      http.start do |h|
        request = Net::HTTP::Post.new(url.path)
        request.basic_auth 'username','password'
        request.set_form_data({'id='=> duid}, ';')
        resp = h.request(request)
        response = resp.body
      end
      Rails.logger.debug response
      return response
    end
  end

  def self.from_file(filename)
    publications = []
    rows = CSV.read(filename)
    rows.each do |row|
      publications << self.map_item(row)
    end
    publications
  end

  def self.get_pubs_uri_for(duid)
    "#{ELEMENTS_URL}/publicationsapi/users/#{duid}/relationships?types=8&detail=full&per-page={1}&page={2}"
  end

  def self.get_all_pubs_uri
    "#{ELEMENTS_URL}/publicationsapi/objects?categories=publications&per-page={0}&page={1}"
  end
 
  def self.for_duids(duids)
     array = Publication.retrieve_pubs(duids)
     array.map {|pub| self.map_item(pub) }
  end

  def self.map_item(pub)
    VivoMapper::Publication.new(
        :uid                                => pub[0],
        :title                              => pub[1],
        :pub_year                           => (pub[2].split("-").first if pub[2].size > 3),
        :volume                             => pub[3],
        :issue                              => pub[4],
        :start_page                         => pub[5],
        :end_page                           => pub[6],
        :author_list                        => pub[7],
        :author_uid                         => pub[8],
        :author_label                       => pub[9],
        :author_rank                        => pub[10],
        :journal_uid                        => pub[11],
        :journal_name                       => pub[12],
        :pub_type                           => pub[13])
#        :pmid                               => pub[],
#        :webpage                            => pub[],
#        :edition                            => pub[],
#        :number                             => pub[],
#        :section                            => pub[],
#        :oclc_number                        => pub[],
#        :abstract                           => pub[],
  end
 
end

