module RN
  module Commands
    module Notes

      class Create < Dry::CLI::Command
        include Paths
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        argument :content, required: true, desc: 'Content of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, content:, **options)
          Note.new(
            Paths.sanitize(title), 
            Paths.sanitize_book(options[:book]
          )).save content
        end
      end

      class Delete < Dry::CLI::Command

        def confirm(title)
          
        end

        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          note = Note.fetch(
              Paths.sanitize(title),
              Paths.sanitize_book(options[:book]))
          if !!note
            note.delete
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          note = Note.fetch(
            Paths.sanitize(title), 
            Paths.sanitize_book(options[:book]))
          if !!note
            note.edit
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          note = Note.fetch(
            Paths.sanitize(old_title), 
            Paths.sanitize_book(options[:book]))
          if !!note
            note.rename(Paths.sanitize(new_title))
          end
        end
      end

      class List < Dry::CLI::Command
        include Errors

        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def pretty_print book:, notes:, length:
          puts "Cuaderno: #{book}"
          if length > 0 
            notes.map { |note| puts "  - #{note}" } 
            puts "  Cantidad #{length}"
          else
            puts "  El libro está vacío"
          end
          puts
        end

        def filter_list options
          if (options[:global])
            [Book.fetch(Paths.global).list_notes]
          elsif (options[:book])
            book = Book.fetch(options[:book])
            if !!book
              [book.list_notes]
            else
              Errors.book_not_found_error  options[:book]
            end
          else
            Note.all_notes
          end
        end

        def call(**options)
          books_notes = filter_list options
          books_notes.map { |book_notes| pretty_print book_notes } unless !books_notes
        end
      end

      class Show < Dry::CLI::Command
        include Paths
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def pretty_print title:, content:
          puts "Nota: #{title}"
          puts content
        end

        def call(title:, **options)
          note = Note.fetch(
            Paths.sanitize(title),
            Paths.sanitize_book(options[:book]))
          if !!note
            pretty_print note.show
          end
        end
      end
    end
  end
end
