require 'i18n'

class Venue
  include Mongoid::Document
  field :initials, type: Array
  field :titles, type: Array
  field :normalized_titles, type: Array
  field :metrics, type: Object
  field :knowledges_area, type: Object 
  field :venue_type, type: String
  field :issn, type: String
  field :info, type: Object

  store_in collection: "venues", database: "avalsist"
end
