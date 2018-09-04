java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.query.QueryFactory'
java_import 'com.hp.hpl.jena.query.QueryExecutionFactory'

module VivoMapper
  class SparqlSelector

    def initialize(sparql)
      @sparql = sparql
      @variables = []
      @bindings = []
    end

    def from_model(model)
      @bindings = []
      query = QueryFactory.create(@sparql)
      qexec = QueryExecutionFactory.create(query, model)
      results = qexec.execSelect()
      @variables = results.get_result_vars.to_a
      while results.has_next
        @bindings << results.next
      end
      qexec.close()
      self
    end

    def as_csv(delimeter=",", quote_char='"')
      result = []
      result << @variables.collect{|v| "#{quote_char}#{v}#{quote_char}"}
      @bindings.each do |binding|
        binding_result = []
        @variables.each do |variable|
          binding_result << "#{quote_char}#{binding.get("?#{variable}").to_s}#{quote_char}"
        end
        result << binding_result
      end
      result.collect{|row| row.join(delimeter)}.join("\n")
    end
  end

  class SparqlConstructor

    def initialize(sparqls=[])
    end

  end
end
