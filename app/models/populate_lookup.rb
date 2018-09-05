class PopulateLookup

  def run
    countries
    research_institutes
    usa_higher_ed
  end

  def countries
    cmd = " curl -o /aact-files/other/countries.csv -G 'https://query.wikidata.org/sparql' \
           --header 'Accept: text/csv'  \
           --data-urlencode query='
       SELECT DISTINCT ?iso2 ?qid ?osm_relid ?itemLabel
       WHERE {
         ?item wdt:P297 _:b0.
         BIND(strafter(STR(?item),\"http://www.wikidata.org/entity/\") as ?qid).
         OPTIONAL { ?item wdt:P1448 ?name .}
         OPTIONAL { ?item wdt:P297 ?iso2 .}
         OPTIONAL { ?item wdt:P402 ?osm_relid .}
         SERVICE wikibase:label { bd:serviceParam wikibase:language \"en,[AUTO_LANGUAGE]\" . }
       }
       ORDER BY ?iso2'"
     system(cmd)
     con = ActiveRecord::Base.connection
     con.execute("DROP TABLE countries;")
     con.execute("CREATE TABLE countries (iso_code varchar, qid varchar, osm_relid varchar, name varchar);")
     con.execute("COPY countries FROM '/aact-files/other/countries.csv' WITH (FORMAT csv);")
  end

  def research_institutes
    cmd = " curl -o /aact-files/other/research_institutes.csv -G 'https://query.wikidata.org/sparql' \
           --header 'Accept: text/csv'  \
           --data-urlencode query='
SELECT DISTINCT  ?qid ?itemLabel ?address ?city_qid ?cityLabel ?state_qid ?stateLabel WHERE {
  ?item (wdt:P31/wdt:P279*) wd:Q31855.   #  Research Institutes
  BIND(STRAFTER(STR(?item), \"http://www.wikidata.org/entity/\") AS ?qid)
  ?item wdt:P131* ?state .
  BIND(STRAFTER(STR(?state), \"http://www.wikidata.org/entity/\") AS ?state_qid)
  ?state wdt:P31 wd:Q35657 .
  ?item wdt:P131 ?city.
    BIND(STRAFTER(STR(?city), \"http://www.wikidata.org/entity/\") AS ?city_qid)
  ?city (wdt:P31/wdt:P279*) wd:Q515 .  # is a city
  ?item wdt:P17 wd:Q30.  #  in the USA
  OPTIONAL { ?item wdt:P969 ?address. }
  SERVICE wikibase:label { bd:serviceParam wikibase:language \"[AUTO_LANGUAGE],en\". }
}'"
     system(cmd)
     con = ActiveRecord::Base.connection
     con.execute("DROP TABLE facilities;")
     con.execute("CREATE TABLE facilities (qid varchar, name varchar, address varchar, city_qid varchar, city varchar, state_qid varchar, state varchar);")
     con.execute("COPY facilities FROM '/aact-files/other/research_institutes.csv' WITH (FORMAT csv);")
  end

  def usa_higher_ed
    cmd = " curl -o /aact-files/other/usa_higher_ed.csv -G 'https://query.wikidata.org/sparql' \
           --header 'Accept: text/csv'  \
           --data-urlencode query='
SELECT DISTINCT  ?qid ?itemLabel ?address ?city_qid ?cityLabel ?state_qid ?stateLabel WHERE {
  ?item (wdt:P31/wdt:P279*) wd:Q3918.
  BIND(STRAFTER(STR(?item), \"http://www.wikidata.org/entity/\") AS ?qid)
  ?item wdt:P131* ?state .
  BIND(STRAFTER(STR(?state), \"http://www.wikidata.org/entity/\") AS ?state_qid)
  ?state wdt:P31 wd:Q35657 .
  ?item wdt:P131 ?city.
    BIND(STRAFTER(STR(?city), \"http://www.wikidata.org/entity/\") AS ?city_qid)
  ?city (wdt:P31/wdt:P279*) wd:Q515 .  # is a city
  ?item wdt:P17 wd:Q30.  #  in the USA
  OPTIONAL { ?item wdt:P969 ?address. }
  SERVICE wikibase:label { bd:serviceParam wikibase:language \"[AUTO_LANGUAGE],en\". }
}'"
     system(cmd)
     con = ActiveRecord::Base.connection
     con.execute("COPY facilities FROM '/aact-files/other/usa_higher_ed.csv' WITH (FORMAT csv);")
  end

end
