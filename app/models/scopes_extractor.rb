class ScopesExtractor
  def initialize(data, delimiter: "/")
    @delimiter = delimiter
    @scopes = extract_scopes(data)
  end

  def [](scope)
    scopes[scope]
  end

  def present?
    scopes.present?
  end

  def each
    return enum_for(:each) unless block_given?
    scopes.each do |scope, value|
      yield scope, value
    end
  end

  def to_scope(additional_scopes={})
    to_new_scope(scopes.merge(additional_scopes))
  end

  def to_new_scope(new_scopes)
    new_scopes.reject{|k,v| k.blank? || v.blank?}.to_a.join(delimiter)
  end

  private
  attr_reader :delimiter, :scopes

  def extract_scopes(path)
    case path
    when Array
      scopes_from_array(path.clone)
    when String
      scopes_from_string(path)
    else
      HashWithIndifferentAccess.new
    end.freeze
  end

  def scopes_from_array(array)
    array.pop if array.size.odd?
    HashWithIndifferentAccess[*array]
  end

  def scopes_from_string(path)
    scopes_from_array(path.split(delimiter))
  end
end
