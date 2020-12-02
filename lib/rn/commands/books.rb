module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        include Paths

        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          Book.new(Paths.sanitize name).save
        end
      end

      class Delete < Dry::CLI::Command
        include Paths
        include Errors

        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          book = Book.fetch(options[:global] ? Paths.global : Paths.sanitize(name))
          if !!book
            book.delete
          else
            Errors.book_not_found_error name
          end
        end
      end

      class List < Dry::CLI::Command

        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def pretty_print book:, notes:
          puts "\nLibro: #{book}"
          puts (notes > 0 ? "  -Tiene #{notes} notas" : "  -Está vacío")
        end

        def call(*)
          Book.list_books.map { |book| pretty_print book }
        end
      end

      class Rename < Dry::CLI::Command
        include Paths
        include Errors
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          book = Book.fetch(old_name)
          if !!book
            book.rename Paths.sanitize new_name
          else
            Errors.book_not_found_error old_name
          end
        end
      end
    end
  end
end
