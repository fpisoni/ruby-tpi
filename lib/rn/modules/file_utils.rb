module RN
    module FileUtils
        require 'tty-editor'

        #General
        def rename_file path, newPath, errorMsg
            begin
                File.rename(path,newPath)
            rescue Errno::ENOENT
                Errors.not_found_error errorMsg
            rescue SystemCallError
                Errors.cant_rename_error errorMsg
            end
        end
        

        #Notes
        def create_note note, book, content
            if Dir.exists?(book.path)
                note.path << '.rn'
                if File.exist?(note.path)
                    Errors.note_already_exists_error "#{note.name}"
                else
                    begin
                        File.open(note.path, "w+") { |f| f.write(content) }
                    rescue Errno::EACCES
                        Errors.not_enough_perms_error "crear la nota #{note.name}"
                    end
                end
            else
                Errors.book_not_found_error book.name
            end
        end

        def edit_note note
            begin
                TTY::Editor.open(note.path)
            rescue Errno::ENOENT
                Errors.note_not_found_error note.name
            rescue Errno::EACCES
                Errors.not_enough_perms_error "editar la nota #{note.name}"
            end
        end

        def rename_note note, title
            new_path = File.join(File.dirname(note.path), title + '.rn')
            begin
                File.rename(note.path, new_path)
            rescue Errno::ENOENT
                Errors.note_not_found_error note.name
            rescue Errno::EACCES
                Errors.not_enough_perms_error "renombrar la nota #{note.name}"
            end
        end

        def delete_note note
            begin
                File.delete(note.path)
            rescue Errno::ENOENT
                Errors.note_not_found_error note.name
            rescue Errno::EACCES
                Errors.not_enough_perms_error "eliminar la nota #{note.name}"
            else
                warn("La nota #{note.name} fue eliminada exitosamente")
            end
        end

        def self.note_content note
            begin
                File.readlines(note.path)
            rescue Errno::ENOENT
                Errors.note_not_found_error note.name
            rescue Errno::EACCES
                Errors.not_enough_perms_error "leer la nota #{note.name}"
            end
        end


        #Books
        def create_book path, title
            begin
                Dir.mkdir(path)
            rescue Errno::EEXIST
                Errors.book_already_exists_error title
            rescue Errno::EACCES
                Errors.not_enough_perms_error "crear el cuaderno #{title}"
            else
                warn "El cuaderno #{title} fue creado exitosamente"
            end
        end

        def delete_book book
            begin
                Dir.delete(book.path)
            rescue Errno::ENOENT
                Errors.book_not_found_error book.title
            rescue Errno::EACCES
                Errors.not_enough_perms_error "crear el cuaderno #{book.title}"
            rescue Errno::ENOTEMPTY
                Errors.not_empty_error book.title
            end
        end 

        def book_notes book
            begin
                Dir.children(book.path)
            rescue Errno::ENOENT
                Errors.book_not_found_error book.name
            end
        end
    end
end