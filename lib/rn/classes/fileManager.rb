module RN
    module FileManager
        require 'tty-editor'

        #initialize
        def self.included(base)
            create_base_dir                         #rescue exceptions
            create_global_dir
        end

        #utils
        def create_base_dir 
            Dir.mkdir default_dir unless Dir.exist? default_dir
        end

        def create_global_dir 
            Dir.mkdir global_dir unless Dir.exist? global_dir
        end

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

    end

    module NoteManager
        include FileManager
        NOTE_TYPE = "la nota"
        
        def create_note note, book
            File.open(File.join(default_dir,book,note[:title]) << '.rn', "w+") do |f|
                f.write(note[:content])
            end
        end

        def retitle_note title, newTitle
            begin
                File.rename(title,newTitle)
            rescue Errno::ENOENT
                not_found_error NoteManager::NOTE_TYPE + title
            rescue SystemCallError
                warn("No tiene permisos suficientes para renombrar la nota #{title}")
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

        def show_notes book
            notes = []
            begin
                Dir.each_child(File.join(default_dir,book)) do |dir|
                    notes << all_notes_in dir
                end
            end
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