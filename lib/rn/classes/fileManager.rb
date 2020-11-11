module RN
    module FileManager
        CREATE_ACTION = "crear"
        RENAME_ACTION = "renombrar"
        READ_ACTION = "leer"
        DELETE_ACTION = "eliminar"
        ILLEGAL_CHARS = %w("\0","/","\"," ")

        #initializion
        def self.included(base)
            create_base_dir                        
            create_global_dir
        end

        def self.create_base_dir 
            Dir.mkdir base_dir unless Dir.exist? base_dir
        end

        def self.create_global_dir 
            Dir.mkdir global_dir unless Dir.exist? global_dir
        end


        #constants methods
        def self.base_dir
            File.join(Dir.home,".my_rns")
        end

        def self.global_dir
            File.join(base_dir,".global")
        end


        #errors
        def self.not_found_error msg
            warn("No se encuentra #{msg}")
        end

        def self.not_enough_perms_error msg
            warn("No tiene permisos suficientes para #{msg}")
        end

        def self.already_exists_error msg
            warn("Ya existe #{msg}")
        end

        def self.cant_delete_error msg
            warn("No se puede borrar #{msg}")            
        end

        def self.title_error
            warn("Error, el título contenía caracteres ilegales")
            warn("Evite comenzar con .")
            warn("Evite usar \\0, /, \\ o espacios")
        end



        #utility methods
        def self.make_text_file book, title, content
            path = File.join(base_dir,book)
            if Dir.exists? path
                if (File.exist? File.join(path,title))
                    already_exists_error "#{NoteManager::NOTE_TYPE} #{title}"
                    return
                end
                File.open(File.join(path, title), "w+") { |f| f.write(content) }
            else
                not_found_error "el libro "
            end
        end

        def self.make_dir book
            begin
                Dir.mkdir(File.join(FileManager.base_dir,book))
            rescue Errno::EEXIST
                FileManager.already_exists_error "#{BookManager::BOOK_TYPE} #{book}"
            #rescue permissions
            end
        end

        def self.open_dir path, dirName = ''
            begin
                Dir.each_child File.join(path,dirName)
            rescue Errno::ENOENT
                not_found_error "#{BookManager::BOOK_TYPE} #{dirName}"
            end
        end

        def self.rename_file title, newTitle, errorMsg
            begin
                File.rename(File.join(FileManager.base_dir,title),File.join(FileManager.base_dir,newTitle))
            rescue Errno::ENOENT
                FileManager.not_found_error "#{errorMsg} #{title}"
            rescue SystemCallError
                FileManager.not_enough_perms_error "#{FileManager::RENAME_ACTION} #{errorMsg}"
            end
        end

        def self.validate_name title
            ILLEGAL_CHARS.all? { |char| !title.include? char} && (!title.start_with? '.')
        end

        def self.validate_book title
            title ? (validate_name title) : ".global"
        end
    end


    module NoteManager
        require 'tty-editor'
        include FileManager
        NOTE_TYPE = "la nota"
        
        def self.create_note note, book
            FileManager::make_text_file(book,note[:title] + '.rn', note[:content])
        end

        def self.rename_note title, newTitle
            rename_file(title, newTitle, NoteManager::NOTE_TYPE)
        end

        def self.edit_note title, book
            #begin
                TTY::Editor.open(fetch_note title,book)
            #rescue
            #
            #end
        end

        def self.delete_note  title, book
            begin
                File.delete(title, book)
            rescue Errno::ENOENT
                not_found_error NoteManager::NOTE_TYPE + title
            #rescue Errno::                 search perms error
            end
        end

        def self.open_note title, book
            begin
                File.open(find_note(title,book), 'r')
            rescue
                
            end
        end

        #single searching methods
        def self.find_note title, book
            begin
                FileManager::open_dir(FileManager::base_dir, book).each do |note| 
                    if title == note 
                        return File.absolute_path(note)
                    end
                end
                FileManager::not_found_error "#{NoteManager::NOTE_TYPE} #{title}"

            rescue Errno::ENOENT
                FileManager::not_found_error "#{BookManager::BOOK_TYPE} #{book}"
            end
        end

        #group note methods
        def list_notes
            notes = []
            open_dir FileManager.base_dir.each do |dir|
                notes << (all_notes_in dir)
            end
            notes
        end

        def all_notes_in book
            notes = []
            open_dir(FileManager.base_dir,book).each {|f| notes << f}
            {book: book, notes: notes}
        end
    end


    module BookManager   
        include FileManager
        BOOK_TYPE = "el libro"

        def create_book book
            FileManager.make_dir(book)
        end

        def rename_book title, newTitle
            FileManager.rename_file(title, newTitle, BookManager::BOOK_TYPE)
        end

        def delete_book title
            if find_book title
                dir = File.join(FileManager.base_dir,title)
                if !Dir.children(dir).length.zero?
                    Dir.each_child(dir) {|note| File.delete(File.join(dir,note))}
                end
                Dir.delete(dir)
            else
                FileManager.not_found_error "#{BookManager::BOOK_TYPE} #{title}"
            end
        end

        def list_books
            Dir.each_child(FileManager.base_dir).reject {|book| book.start_with? '.'}
        end

        def find_book title
            FileManager.open_dir(FileManager.base_dir).include? title
        end
    end
end