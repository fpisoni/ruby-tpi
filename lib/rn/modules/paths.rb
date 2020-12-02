module RN
    module Paths
        ILLEGAL_CHARS_REGEX = /[\.\/\s,]/
        REPLACEMENT_HASH = {
            '.' => '-',
            ',' => '-',
            ' ' => '_',
            '/' => '_',
        }


        #initializion
        def self.included(base)
            create_base_dir                      
            create_global_dir
            #create_config_file
        end

        def self.create_base_dir 
            Dir.mkdir base_dir unless Dir.exist? base_dir
        end

        def self.create_global_dir 
            Dir.mkdir global_dir unless Dir.exist? global_dir
        end

        #def self.create_config_file

        #def config_file


        #constants methods
        def self.base_dir
            File.join(Dir.home,".my_rns")
        end

        def self.global_dir
            book_path global
        end

        def self.book_path title
            File.join(base_dir, title)
        end

        def self.note_path title, book
            File.join(base_dir,book,title)
        end

        def self.global
            'global'
        end

        def book_from_note path
            File.basename(File.dirname(path))
        end

        def self.sanitize title
            sanitized = title.gsub(ILLEGAL_CHARS_REGEX,REPLACEMENT_HASH)
            if sanitized != title
                Errors.title_error
            end
            sanitized
        end

        def self.sanitize_book title
            title ? sanitize(title) : global
        end
    end
end