class SearchResult < ApplicationRecord
  belongs_to :user

  validates :links_count, numericality: { only_integer: true }
  validates :adwords_count, numericality: { only_integer: true }
end
