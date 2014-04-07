require 'scopes_extractor'

class EventsController < ApplicationController
  def index
    scopes = ScopesExtractor.new(params[:scopes])
    events = db.
      channel(scopes[:channel]).
      query(params[:q]).
      tag(scopes[:tag]).
      mention(scopes[:mention]).
      author(scopes[:author]).
      tag(scopes[:tag]).
      after(scopes[:after]).
      page(params[:page]).
      per(params[:per])
    render locals: {events: events.load, channels: db.channels, scopes: scopes, renderer: EventRenderer.new(view_context, scopes)}
  end

  private
  def db
    EventsDB.new
  end
end
