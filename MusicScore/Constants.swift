//
//  Constants.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import Foundation
import SwiftUI

struct Score: Identifiable {
    var title: String
    var pageCount: Int
    var size: Float
    let fileName: String
    let id = UUID()
}

struct Constants {
    static var scores: [Score] = [Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Extremely long line that is so long that it might go off the page. This line is too long and is made up of many characters.", pageCount: 20, size: 3.0 , fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster"), Score(title: "Hello", pageCount: 11, size: 1.1, fileName: "26F-Concertmaster"), Score(title: "Hello1", pageCount: 2, size: 2.1, fileName: "26F-Concertmaster"), Score(title: "Hello2", pageCount: 3, size: 15, fileName: "26F-Concertmaster")]
    
    static let toolbarIconSize: CGFloat = 24
    
    static let commonColors: [Color] = [
        .black, .white, .red, .orange, .yellow, .green, .blue, .indigo, .purple, .brown, .pink, .cyan, .teal, .mint
    ]
}
