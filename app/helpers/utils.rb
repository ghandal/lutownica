module Utils
  extend self

  def tag_regexp
    /(?<=\A|\s|,|;)#([^,;\s\?]+)/i
  end

  def mention_regexp
    /(?<=\A|\s)([a-z0-9_\.-]+)(?=:\s)/i
  end

  def action_regexp
    /^\u0001ACTION (.+)\u0001/u
  end
end
