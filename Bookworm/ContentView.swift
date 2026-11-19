//
//  ContentView.swift
//  Bookworm
//
//  Created by Remitbee on 17/11/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ])
    var books: [Book]

    @State private var showingAddScreen = false
    @State private var path = [Book]()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? .red : .primary)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
            .onAppear {
                if ProcessInfo.processInfo.arguments.contains("-seedData") && books.isEmpty {
                    let sample1 = Book(title: "The Hobbit", author: "J.R.R. Tolkien", genre: "Fantasy", review: "An unforgettable adventure through Middle-earth. Bilbo Baggins is the ultimate reluctant hero.", rating: 5, date: .now)
                    let sample2 = Book(title: "Twilight", author: "Stephenie Meyer", genre: "Romance", review: "Not my personal cup of tea; slow pacing and dramatic dialogue.", rating: 1, date: Calendar.current.date(byAdding: .day, value: -4, to: .now) ?? .now)
                    let sample3 = Book(title: "Dune", author: "Frank Herbert", genre: "Fantasy", review: "A monumental work of science fiction, political intrigue, and desert survival.", rating: 4, date: Calendar.current.date(byAdding: .day, value: -12, to: .now) ?? .now)
                    let sample4 = Book(title: "The Shining", author: "Stephen King", genre: "Horror", review: "Genuinely chilling atmospheric horror with iconic suspense.", rating: 4, date: Calendar.current.date(byAdding: .day, value: -25, to: .now) ?? .now)
                    
                    modelContext.insert(sample1)
                    modelContext.insert(sample2)
                    modelContext.insert(sample3)
                    modelContext.insert(sample4)
                }
                
                if ProcessInfo.processInfo.arguments.contains("-showDetail") {
                    if let target = books.first(where: { $0.title == "The Hobbit" }) ?? books.first {
                        path.append(target)
                    }
                }
                
                if ProcessInfo.processInfo.arguments.contains("-showAdd") {
                    showingAddScreen = true
                }
            }
        }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our query
            let book = books[offset]

            // delete it from the context
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
