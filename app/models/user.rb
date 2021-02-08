class User < ApplicationRecord
    validates :email, 
        uniqueness: { case_sensitive: false }, 
        presence: true, 
        length: { minimum: 7, maximum: 19}, 
        format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, 
        uniqueness: { case_sensitive: true }, 
        presence: true, 
        length: { minimum: 3, maximum: 15}
    
    after_save :create_global_book
    
    has_secure_password    
    has_many :books

    def create_global_book
        Book.create(user:self, name:'Global book')
    end

    def notes
        self.books.map { |b| b.notes }.flatten
    end
end
