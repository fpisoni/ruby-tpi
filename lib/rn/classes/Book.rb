module RN
    class Book < RNFile
        BOOK_MSG = "el libro"

        #class methods
        class << self
            def from_dir path
                new File.basename(path), path
            end

            def list_books
                all.map(&:show)
            end

            def all
                Dir.children(Paths.base_dir).map do |title|
                    Book.from_dir(Paths.book_path(title))
                end
            end

            def fetch title
               all.find { |book| book.title == title  }
            end
        end


        #creation
        def initialize title, path = Paths.book_path(title)
            super(title, path)
        end

        def save
            create_book @path, @title
        end


        #operations
        def delete
            notes.map { |note| Note.new(note, @title).delete }
            if !!delete_book(self)
                warn("El #{global? ? '' : 'cuaderno'} #{name} fue #{global? ? 'vaciado' : 'eliminado'} correctamente")
            end
        end

        def rename newTitle
            if !!(rename_file(@path, Paths.book_path(newTitle), newTitle))
                warn("El libro #{@title} se ha renombrado exitosamente a #{newTitle}")
                @title = newTitle
            end
        end

        def show
            { book: name, notes: notes.length }
        end

        def list_notes
            { book: name, notes: notes.map { |note| File.basename(note,'.rn')  }, length: notes.length }
        end


        #utils
        def name
            global? ? 'Cuaderno global' : @title
        end

        def global?
            @title == Paths.global
        end

        def notes
            book_notes(self)
        end

        def find_note title
            notes.find { |note| note == title }
        end
    end
end