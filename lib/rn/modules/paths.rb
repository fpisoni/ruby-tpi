module RN
    module Paths
        CREATE_ACTION = "crear"
        RENAME_ACTION = "renombrar"
        READ_ACTION = "leer"
        DELETE_ACTION = "eliminar"
        ILLEGAL_CHARS = %w("\0","/","\"," ")

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
            book_path '.global'
        end

        def self.book_path title
            File.join(base_dir,title)
        end

        def self.note_path title, book = '.global'
            File.join(base_dir,book,title)
        end

        def validate_name title
            ILLEGAL_CHARS.all? { |char| !title.include? char}
        end

        def validate_book title
            title ? (validate_name title) : ".global"
        end
    end
end