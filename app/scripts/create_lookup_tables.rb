
#  Countries
"curl -o countries.csv -G 'https://query.wikidata.org/sparql' \
     --header "Accept: text/csv"  \
     --data-urlencode query='
 SELECT DISTINCT ?iso2 ?qid ?osm_relid ?itemLabel
 WHERE {
  ?item wdt:P297 _:b0.
  BIND(strafter(STR(?item),"http://www.wikidata.org/entity/") as ?qid).
  OPTIONAL { ?item wdt:P1448 ?name .}
  OPTIONAL { ?item wdt:P297 ?iso2 .}
  OPTIONAL { ?item wdt:P402 ?osm_relid .}
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en,[AUTO_LANGUAGE]" . }
 }
 ORDER BY ?iso2"

 create table lookup_countries (iso_code varchar, qid varchar, osm_relid varchar, name varchar);
copy lookup_countries from '/Users/tibbs001/work/duke_vivo_mapper/lookups/countries.csv' WITH (FORMAT csv);


#  Cities   (Q35657)
#
curl -o cities.csv -G 'https://query.wikidata.org/sparql' \
     --header "Accept: text/csv"  \
     --data-urlencode query='

SELECT DISTINCT ?city ?cityLabel ?state ?stateLabel ?country ?countryLabel
WHERE
{
    ?city wdt:P31 wd:Q1093829 .
    OPTIONAL { ?city wdt:P131 ?state .}
    OPTIONAL { ?state wdt:P31/wdt:P279* wd:Q35657 .}
    OPTIONAL { ?city wdt:P17 ?country .}
    OPTIONAL { ?country wdt:P31 wd:6256 .}
    SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
} '

create table lookup.lookup_cities (city varchar, city_label varchar, state varchar, state_label varchar, country varchar, country_label varchar);
copy lookup_countries from '/Users/tibbs001/work/duke_vivo_mapper/lookups/cities.csv' WITH (FORMAT csv);

