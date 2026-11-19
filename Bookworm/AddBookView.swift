//
//  AddBookView.swift
//  Bookworm
//
//  Created by Remitbee on 18/11/26.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var title = ProcessInfo.processInfo.arguments.contains("-sampleAdd") ? "Project Hail Mary" : ""
    @State private var author = ProcessInfo.processInfo.arguments.contains("-sampleAdd") ? "Andy Weir" : ""
    @State private var rating = ProcessInfo.processInfo.arguments.contains("-sampleAdd") ? 5 : 3
    @State private var genre = "Fantasy"
    @State private var review = ProcessInfo.processInfo.arguments.contains("-sampleAdd") ? "A fantastic sci-fi survival story with heart, humor, and incredible science." : ""
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var hasValidForm: Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }

                Section {
                    Button("Save") {
                        // add the book
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(!hasValidForm)
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

#Preview {
    AddBookView()
}
