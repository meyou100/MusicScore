//
//  HomeView.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var showImporter: Bool = false
    @Query private var scores: [Score] = []
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Scores")
                        .font(.system(size: 40))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Menu {
                        Button {
                            showImporter = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                            Text("Import")
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 25))
                    }
                }
                .padding(20)
                .fileImporter(
                    isPresented: $showImporter,
                    allowedContentTypes: [.pdf],
                    allowsMultipleSelection: false
                ) { result in
                        switch result {
                        case .success(let urls):
                            guard let url = urls.first else { return }
                            
                            guard url.startAccessingSecurityScopedResource() else { return }
                            defer { url.stopAccessingSecurityScopedResource() }
                            
                            do {
                                let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(url.lastPathComponent)
                                
                                if FileManager.default.fileExists(atPath: destination.path) {
//                                    destination.path. deal with if file already exists
                                }
                                
                                try FileManager.default.copyItem(at: url, to: destination)
                                
                                if let s = Score(fileName: destination.lastPathComponent) {
                                    context.insert(s)
                                } else {
                                    print("Error creating score")
                                }
                            } catch {
                                print("Error copying file: \(error.localizedDescription)")
                            }
                        case .failure(let error):
                            print("Failed with error: \(error.localizedDescription)")
                        }
                }
                
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                        .frame(height: 1)
                    
                    List {
                        if scores.count > 0 {
                                ForEach(scores) { score in
                                    NavigationLink {
                                        ScorePage(score: score, pageIndex: 0)
                                    } label: {
                                        VStack {
                                            Text(score.title)
                                                .font(.title)
                                                .bold()
                                                .foregroundStyle(.scoreText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(1)
                                            Text(String(format: "%d pages | %.2f MB", score.pageCount, score.size))
                                                .font(.subheadline)
                                                .foregroundStyle(.scoreText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(1)
                                        }
                                        .frame(height: 100)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(
                                        ZStack(alignment: .bottom) {
                                            Color(.systemBackground)
                                            
                                            if (score.id != scores.last?.id) {
                                                Rectangle()
                                                    .fill(.black.opacity(0.2))
                                                    .frame(height: 1)
                                                    .padding(.horizontal, 20)
                                            }
                                        }
                                    )
                                }
                        } else {
                            Text("Import a score to start")
                                .frame(maxWidth: .infinity)
                                .listRowBackground(Color.clear)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Score.self, inMemory: true)
}
