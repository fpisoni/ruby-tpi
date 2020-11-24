module RN
    module FileOperations

        def rename_file path, newPath, errorMsg
            begin
                File.rename(path,newPath)
            rescue Errno::ENOENT
                Errors.not_found_error errorMsg
            rescue SystemCallError
                Errors.cant_rename_error errorMsg
            end
        end

        def create_book path
            begin
                Dir.mkdir(path)
            rescue Errno::EEXIST
                Errors.book_already_exists_error File.basename(path)
            #rescue permissions 
            else
                warn "El libro #{File.basename(path)} fue creado exitosamente"
            end
        end

        def create_note book, title, content
            if Dir.exists? book.path
                if (File.exist? File.join(book.path,title))
                    Errors.note_already_exists "#{title}"
                else
                    File.open(File.join(book.path, title + '.rn'), "w+") { |f| f.write(content) }
                end
            else
                Errors.book_not_found book.title
            end
        end

        def show_note note
            begin
                File.open(note.path, "r") do |file|
                    { note: note.title, content: file.readlines.map(&:chomp) }
                end
            rescue Errno::EEXIST
                Errors.note_not_found_error note.title
            end
        end

        def delete_note note
            begin
                File.remove(note.path)
            rescue Errno::ENOENT
                Errors.note_not_found_error note.title
            end
        end

        def delete_book book
            begin
                Dir.remove(book.path)
            rescue Errno::ENOENT
                Errors.book_not_found_error book.title
            end
        end 
    end
end