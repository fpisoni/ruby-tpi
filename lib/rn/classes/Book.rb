module RN
    class Book < RNFile
        BOOK_MSG = "el libro"
        
        @@all_books = []
        @notes = []

        class << self
            attr_reader :all_books

            def list_books
                @@all_books.map(&:title)#.filter {|title| !title.start_with? '.'}
            end

            def exists? title
                @@all_books.any? {|book| book.title == title}
            end

            def fetch_book title
                @@all_books.find {|title| book.title == title}
            end
        end

        def initialize title
            @@all_books << self
            super(title, Paths.book_path(title))
            create_book @path
        end

        def delete
            @notes.map &:delete                      
            FileOperations.delete_book self
            @@all_books.delete_if {|book| book.title == title}
        end

        def rename title, newTitle
            if rename_book(@path, Path.book_path(newTitle), newTitle)
                @title = newTitle
                warn("El libro #{title} se ha renombrado exitosamente a #{newTitle}")
            end
        end

        def add_note note
            @notes << note
        end

        def notes
            @notes || warn("El libro #{title} está vacío")          #move to errors?
        end

        def list_notes
            { book: self.title, notes: @notes.map(&:title) }
        end
    end
end