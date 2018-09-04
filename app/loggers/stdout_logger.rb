class StdoutLogger

  def initialize(options={})
    @only = options[:only] || []
  end

  def log(command_name,command_body)
    if @only.empty? || @only.include?(command_name)
      STDOUT.write <<-EOS
        #{command_name}:
        #{command_body}
      EOS
    end
  end

end
