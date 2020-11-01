module RN
    module FileManager
        require 'tty-editor'

        RENAME_ACTION = "renombrar"
        CREATE_ACTION = "crear"
        READ_ACTION = "leer"

        #initializion
        def self.included(base)
            create_base_dir                        
            create_global_dir
        end

        def create_base_dir 
            Dir.mkdir default_dir unless Dir.exist? default_dir
        end

        def create_global_dir 
            Dir.mkdir global_dir unless Dir.exist? global_dir
        end

        #utility methods
        def make_text_file path, content
            #begin
                File.open(path, "w+") do |f|
                    f.write(content)
                end
            #rescue

        end

        def make_dir path
            #begin
                Dir.mkdir(path)
            #rescue

        end

        def rename_file

        end

        #constants methods
        def global_dir
            File.join(default_dir,'global')
        end

        def default_dir
            File.join(Dir.home,".my_rns")
        end

        #errors
        def not_found_error msg
            warn("No se encuentra #{msg}")
        end

        def already_exists_error msg
            warn("Ya existe #{msg}")
        end

        def not_enough_perms_error msg
            warn("No tiene permisos suficientes para #{msg}")
        end

    end

    module NoteManager
        include FileManager
        NOTE_TYPE = "la nota"
        
        def create_note note, book
            make_text_file(File.join(default_dir,book,note[:title]) + '.rn', note[:content])
        end

        def retitle_note title, newTitle
            begin
                File.rename(title,newTitle)
            rescue Errno::ENOENT
                not_found_error NoteManager::NOTE_TYPE + title
            rescue SystemCallError
                not_enough_perms_error FileManager::RENAME_ACTION + NoteManager::NOTE_TYPE + title
            end
        end

        def edit_note title, book
            #begin
                TTY::Editor.open(fetch_note title,book)
            #rescue
            #
            #end
        end

        def delete_note  title
            begin
                File.delete((find_by_note title))
            rescue Errno::ENOENT
                not_found_error NoteManager::NOTE_TYPE + title
            #rescue Errno::                 search perms error
            end
        end

        #single searching methods
        def fetch_note title, book
            begin
                Dir.each_child(File.join(default_dir,book)) do |note| 
                    if title == note return File.absolute_path(note)
                end
                not_found_error NoteManager::NOTE_TYPE + title
            rescue Errno::ENOENT
                not_found_error BookManager::BOOK_TYPE + book
            end
        end

        def find_note title

        end

        #group note methods
        def show_all_notes
            notes = []
            open_dir default_dir.each do |dir|
                notes << all_notes_in dir
            end
            notes
        end

        def all_notes_in book
            notes = []
            open_dir File.join(default_dir,book).each {|f| notes << f}
            {book: book, notes: notes}
        end
    end

    module BookManager   
        include FileManager
        BOOK_TYPE = "el libro"

        def create_book book
            begin
                Dir.mkdir(File.join(default_dir,book))
            rescue Errno::EEXIST
                not_found_error BookManager::BOOK_TYPE + book
            #rescue permissions
            end
        end

        def delete_book
            delete_file
        end

        def get_books
            find_by_name()
        end
    end
end