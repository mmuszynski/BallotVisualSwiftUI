//
//  BallotVisualApp.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI
import Balloting

@main
struct BallotVisualApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ElectionDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
