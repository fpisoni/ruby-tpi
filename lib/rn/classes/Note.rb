module RN
    class Note < RNFile

        NOTE_MSG = "la nota"

        class << self
            def all_notes
                Book.all.map &:list_notes
            end

            def fetch title, book_name
                book = Book.fetch(book_name)
                if !!book
                    note = book.find_note(title + '.rn')
                    if !!note
                        new(note, book.title)
                    else
                        Errors.note_not_found_error(title)
                    end
                else
                    Errors.book_not_found_error book_name
                end
            end
        end

        #creation
        def initialize title, book
            super(title, Paths.note_path(title, book))
        end

        def save content
            if !!create_note(self, book, content)
                warn("La nota #{name} fue guardada exitosamente")
            end
        end

        #operations
        def rename newTitle
            if !!rename_note(self, newTitle)
                warn("La nota #{name} se ha renombrado exitosamente a #{newTitle}")
            end
        end

        def edit
            edit_note(self)
        end

        def show 
            { title: name, content: FileUtils.note_content(self) }
        end

        def delete
            if !!delete_note(self)
                warn("La nota #{name} fue eliminada exitosamente")
            end
        end


        # utils
        def book
            Book.from_dir File.dirname @path
        end

        def name
            File.basename(@title, '.rn')
        end
    end
end