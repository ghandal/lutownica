class EventsDB
  def initialize
    reset_scopes
  end

  def page(page)
    @page = page || 1
    self
  end

  def per(per)
    @per = (1..250).cover?(per) ? per : 100
    self
  end

  def after(date)
    scope ["created_at >= ?", date]
  end

  def author(author)
    scope nick: author
  end

  def mention(mention)
    query(mention)
  end

  def tag(tag)
    query(tag)
  end

  def network(network)
    scope network: network
  end

  def channel(channel)
    scope channel: channel
  end

  def query(query)
    scope ["to_tsvector('simple', message) @@ to_tsquery(?)", query]
  end

  def load
    scopes.
      compact.
      reduce(Event){|event, scope| event.where(scope)}.
      order(:created_at).
      page(@page).
      per(@per).tap{ reset_scopes }
  end

  def channels
    Event.pluck("DISTINCT channel").sort
  end

  private
  attr_reader :scopes, :tag_scope, :mention_scope, :after_scope
  def reset_scopes
    @page = 1
    @per = 100
    @scopes = []
  end

  def scope(scope)
    scopes << scope if present?(scope)
    self
  end

  def present?(scope)
    case scope
    when Array
      scope.all?(&:present?)
    when Hash
      scope.values.all?(&:present?)
    else
      scope.present?
    end
  end
end
