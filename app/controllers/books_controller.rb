class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :export]
  before_action :set_all_books, only: [ :index, :mass_export ]
  before_action :require_user
  before_action :require_same_user, except: [ :index, :new, :create, :mass_export ]

  def index
  end

  def show
    @show_notes = @book.notes.first(5)
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    book = Book.new(book_params)
    book.user = current_user

    respond_to do |format|
      if book.save
        format.html { redirect_to book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: book }
      else
        format.html { render :new }
        format.json { render json: book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.global? ? @book.notes.map { |note| note.destroy } : @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @exported_book = @book.export
  end

  def mass_export
    @exported_books = @books.map { |book| book.export }
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def set_all_books
      @books = current_user.books
    end

    def book_params
      params.require(:book).permit(:name)
    end

    def require_same_user
      if current_user != @book.user
        redirect_to 'root'
      end
    end
end
