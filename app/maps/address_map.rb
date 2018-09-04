module AddressMap
  include RdfPrefixes

  extend self

  def uri(namespace,address)
    "#{namespace}addr#{address.uid}"
  end

  def types(address)
    address.address_type == 'work_mailing' ? [core("USPostalAddress")]  : [core("Address")]
  end

  def inferred_types(a)
    [owl("Thing")]
  end

  def properties(a)
    {
      rdfs("label")             => a.label,
      core("address1")          => (a.street   if a.street),
      core("addressCity")       => (a.city     if a.city),
      core("addressState")      => (a.state    if a.state),
      core("addressPostalCode") => (a.zip_code if a.zip_code),
      core("addressCountry")    => (a.country  if a.country && a.country != 'US'),
      core("mailingAddressFor") => VivoMapper::Person.new(:uid => a.person_uid, :phone => a.phone, :type => 'FacultyMember'),
    } 
  end

  def self.sparql_constructs(person_uri)
    [self.sparql_construct1(person_uri), self.sparql_construct2(person_uri)]
  end

  def self.sparql_construct1(person_uri)
    # the whole address and all links to it if this is the only person at that address.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT {
            <#{person_uri}> vivo:workPhone        ?phone .
            <#{person_uri}> vivo:mailingAddress   ?address .
            ?address        ?address_p            ?address_o .
        }  WHERE { 
            <#{person_uri}> vivo:workPhone        ?phone .
            <#{person_uri}> vivo:mailingAddress   ?address .
            ?address        ?address_p            ?address_o .
            { SELECT distinct ?address (count(?people) as ?count)
               WHERE { <#{person_uri}> vivo:mailingAddress      ?a .
                       ?a              vivo:mailingAddressFor   ?people .
                     }  GROUP BY ?a
             }   } HAVING (?count = 1)"
  end

  def self.sparql_construct2(person_uri)
    # if address used by other people, return only this person's link to the address.
    "PREFIX vivo: <http://vivoweb.org/ontology/core#>
     CONSTRUCT {
            <#{person_uri}> vivo:workPhone        ?phone .
            <#{person_uri}> vivo:mailingAddress   ?address .
        }  WHERE { 
            <#{person_uri}> vivo:workPhone        ?phone .
            <#{person_uri}> vivo:mailingAddress   ?address .
            { SELECT distinct ?address (count(?people) as ?count)
               WHERE { <#{person_uri}> vivo:mailingAddress      ?a .
                       ?a              vivo:mailingAddressFor   ?people .
                     }  GROUP BY ?a
             }   } HAVING (?count > 1)"
  end

end
