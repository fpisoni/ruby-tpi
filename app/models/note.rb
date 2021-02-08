class Note < ApplicationRecord
    validates :name, 
        uniqueness: { scope: :book_id, message: "The book already has a note named like that", case_sensitive: true }, 
        presence: true, 
        length: { minimum: 3, maximum: 15}
    validates :content, 
        presence: true

    belongs_to :user
    belongs_to :book

    def export exported_choice = :html
        PandocRuby.convert(self.content, from: :markdown, to: exported_choice)
    end
end
