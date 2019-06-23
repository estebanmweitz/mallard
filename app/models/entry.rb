# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :feed

  validates :feed, :title, :url, :published_at, :guid, presence: true
  validates :feed_id, uniqueness: { scope: :guid }

  def self.create_from_feedjira(feed_id, entry)
    identifier = entry.entry_id || entry.url
    return if Entry.exists?(feed_id: feed_id, guid: identifier)

    title = entry.title.presence || entry.url
    Entry.create!(
      feed_id: feed_id,
      title: title,
      url: entry.url,
      author: entry.author,
      published_at: entry.published,
      guid: identifier,
      content: entry.content || entry.summary
    )
  end
end