//
//  HomeView.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import SwiftUI

struct HomeView: View {
    @ScaledMetric private var titleFontSize: CGFloat = 40
    @ScaledMetric private var menuFontSize: CGFloat = 25
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Scores")
                        .font(.system(size: titleFontSize))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Menu {
                        Button {
                            
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
                            .font(.system(size: menuFontSize))
                    }
                }
                
                Divider()
                
                ScrollView(.vertical) {
                    ForEach(Constants.scores) { score in
                        NavigationLink {
                            ScorePage(score: score)
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
                        Divider()
                    }
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    HomeView()
}
