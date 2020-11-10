module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        include BookManager 
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          create_book(name)
        end
      end

      class Delete < Dry::CLI::Command
        include BookManager
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          warn "TODO: Implementar borrado del cuaderno de notas con nombre '#{name}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        include BookManager
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          list_books.each {|book| puts book}
        end
      end

      class Rename < Dry::CLI::Command
        include BookManager
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          if (FileManager.validate_name new_name)
            rename_book old_name, new_name
          else
            FileManager.title_error
          end
        end
      end
    end
  end
end
