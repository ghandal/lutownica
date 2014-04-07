class EventRenderer
  include Utils

  def initialize(context, scopes)
    @context = context
    @scopes  = scopes
  end

  def render(event)
    context.render partial(event), nick: event.nick,
                                   date: event.created_at,
                                   channel: event.channel,
                                   message: decorate(event.message),
                                   scopes: scopes
  end

  def decorate(message)
    context.auto_link(
      message.
        gsub(action_regexp, '\1').
        gsub(tag_regexp, &tag).
        gsub(mention_regexp, &mention)
    )
  end

  private
  attr_reader :context, :scopes

  def partial(event)
    if %(join part message notice).include?(event.event)
      if action?(event.message)
        'action'
      else
        event.event
      end
    end
  end

  def action?(message)
    message =~ action_regexp
  end

  def tag
    -> tag { context.link_to tag, context.events_path(scopes.to_scope(tag: tag.gsub(/^#/,''))), class: 'label label-info' }
  end

  def mention
    -> mention { context.link_to mention, context.events_path(scopes.to_scope(mention: mention)), class: 'label label-success' }
  end
end
