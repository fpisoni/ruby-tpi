class Book < ApplicationRecord
    belongs_to :user
    
    validates :name, 
        uniqueness: { scope: :user_id, message: 'The User already has a book named that way' },
        presence: true, 
        length: { minimum: 3, maximum: 15}

    has_many :notes

    def global?
        name == 'Global book'
    end

    def export
        {
            book: self.name,
            exported_notes: self.notes.map do |note| 
                {
                    note: note.name,
                    converted_content: note.export
                } 
            end
        }
    end
end
