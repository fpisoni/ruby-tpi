class NotesController < ApplicationController
  before_action :set_note, only: [ :show, :edit, :update, :destroy, :export ]
  before_action :require_user   #same user as note
  before_action :require_same_user, except: [ :index, :new, :create ]
  before_action :set_user_books, only: [ :new, :create, :index, :edit, :update ]
  before_action :set_index_notes, only: [ :index ]

  def index
  end

  def show
  end

  def new
    @note = Note.new
    @selected_book = @user_books.first
  end

  def edit
    @selected_book = @note.book
  end

  def create
    @note = Note.new(note_params)
    @note.user = current_user

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    @exported = @note.export
  end

  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:name, :content).merge(book: Book.find(params[:note][:book]))
    end

    def set_user_books
      @user_books = current_user.books
    end

    def set_index_notes
      if params[:filter] && params[:filter].length > 0
        @book = @user_books.find(params[:filter])
        @notes = @book.notes
      else
        @notes = current_user.notes
      end
    end

    def require_same_user
      if current_user != @note.user
        redirect_to 'root'
      end
    end
end
