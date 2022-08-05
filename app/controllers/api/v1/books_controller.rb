class Api::V1::BooksController < ApplicationController
  def index
    render json: Book.all
  end

  def show
    book = Book.find(params[:id])
    render json: book
  end

  def create
    Book.create(book_params)
  end

  def update
    Book.update(params[:id], book_params)
  end

  def destroy
    Book.destroy(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:title,
                  :author,
                  :genre,
                  :summary,
                  :number_sold
                )
  end
end
