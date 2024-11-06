7.times {|i| Author.create(name: "Author #{i+1}", biography: "Biography #{i+1}")}

49.times do |i|
    Book.create(
        title: "Book #{i+1}",
        synopsis: "Synopsis #{i+1}",
        published_at: (i*49).days.ago,
        author_id: Author.find_by(name: "Author #{i%7 + 1}").id
    )
end

7.times do |i|
    User.create(
        name: "User #{i+1}",
        email: "user#{i+1}@email.com"
    )
end

Rental.create(
    book_id: Book.first.id,
    user_id: User.first.id,
    start_date: Date.today,
    end_date: 10.days.from_now
)

Rental.create(
    book_id: Book.last.id,
    user_id: User.last.id,
    start_date: Date.today,
    end_date: 2.days.from_now
)


