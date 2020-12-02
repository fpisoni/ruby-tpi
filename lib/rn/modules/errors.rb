module RN
    module Errors
        def self.book_not_found_error title
            warn("No se encuentra el cuaderno #{title}")
        end

        def self.note_not_found_error title
            warn("No se encuentra la nota #{title}")
        end

        def self.not_found_error msg
            warn("No se encuentra #{msg}")
        end

        def self.not_empty_error msg
            warn("El cuaderno #{msg} no está vacío")
        end

        def self.not_enough_perms_error msg
            warn("No tiene permisos suficientes para #{msg}")
        end

        def self.cant_delete_error msg
            warn("No se puede borrar #{msg}")            
        end

        def self.book_already_exists_error title
            warn("El cuaderno #{title} ya existe")
        end

        def self.note_already_exists_error title
            warn("La nota #{title} ya existe")
        end

        def self.title_error
            warn("El título contenía caracteres ilegales, por lo que fue modificado")
            warn("Evite usar los siguientes caracteres:\n     '/', '\\', '.', ',', o espacios")
        end
    end
end