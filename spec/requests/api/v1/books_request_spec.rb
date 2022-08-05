require 'rails_helper'

describe "Books API" do
  it 'sends a list of books' do
    create_list(:book, 3)

    get '/api/v1/books'

    expect(response).to be_successful

    books = JSON.parse(response.body, symbolize_names: true)

    expect(books.size).to eq 3

    books.each do |book|
      expect(book).to have_key :id
      expect(book[:id]).to be_an Integer

      expect(book).to have_key :title
      expect(book[:title]).to be_a String

      expect(book).to have_key :author
      expect(book[:author]).to be_a String

      expect(book).to have_key :genre
      expect(book[:genre]).to be_a String

      expect(book).to have_key :summary
      expect(book[:summary]).to be_a String

      expect(book).to have_key :number_sold
      expect(book[:number_sold]).to be_an Integer
    end
  end

  it 'can get one book by its id' do
    id = create(:book).id

    get "/api/v1/books/#{id}"

    expect(response).to be_successful

    book = JSON.parse(response.body, symbolize_names: true)

    expect(book).to have_key :id
    expect(book[:id]).to be_an Integer

    expect(book).to have_key :title
    expect(book[:title]).to be_a String

    expect(book).to have_key :author
    expect(book[:author]).to be_a String

    expect(book).to have_key :genre
    expect(book[:genre]).to be_a String

    expect(book).to have_key :summary
    expect(book[:summary]).to be_a String

    expect(book).to have_key :number_sold
    expect(book[:number_sold]).to be_an Integer
  end

  it 'can create a new book' do
    valid_attributes = {
      title: "The Shining",
      author: "Stephen King",
      genre: "Horror",
      summary: Faker::Lorem.paragraph,
      number_sold: 8389283
    }

    headers = { "CONTENT_TYPE" => "application/json" }

    create_list(:book, 3)

    post "/api/v1/books", headers: headers, params: JSON.generate(valid_attributes)

    expect(response).to be_successful

    new_book = Book.last

    expect(new_book.title).to eq valid_attributes[:title]
    expect(new_book.author).to eq valid_attributes[:author]
    expect(new_book.genre).to eq valid_attributes[:genre]
    expect(new_book.summary).to eq valid_attributes[:summary]
    expect(new_book.number_sold).to eq valid_attributes[:number_sold]
  end

  it 'updates an existing book' do
    id = create(:book).id
    previous_name = Book.last.title
    new_attribute = { title: "Charlotte's Web"}
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/books/#{id}", headers: headers, params: JSON.generate(new_attribute)

    expect(response).to be_successful

    changed_book = Book.find(id)
    expect(changed_book.title).to eq new_attribute[:title]
  end
end
