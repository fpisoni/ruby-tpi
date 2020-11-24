module RN
    class Note < RNFile
        require 'tty-editor'

        NOTE_MSG = "la nota"

        class << self
            def list_notes filter
                filter.call( Book.all_books.map { |book| book.list_notes })
            end

            def fetch title, book
                Book.fetch_book(book).notes.find(title) || Errors.not_found "#{NOTE_MSG} #{title}"
            end
        end

        def initialize title, content, book = nil
            path = book.nil? ? Paths.note_path(title, book) : Paths.note_path(title)
            super(title, path)
            @book = Book.fetch_book(title)
            if create_note(@book, title, content)
                warn("La nota #{title} fue creada exitosamente")
                @book.add_note self
            end
        end

        def rename title, newTitle
            if rename_note(@path, newTitle)
                @title = newTitle
                @path = Paths.note_path(newTitle, @book.title)
            end
        end

        def edit
            begin
                TTY::Editor.open(@path)
            rescue Errno::ENOENT
                Errors.note_not_found_error @title
            end
        end

        def show 
            FileOperations.open_note(self)
        end

        def delete 
            if FileOperations.delete_note(self)
                #cleanup books
            end
        end
    end
end