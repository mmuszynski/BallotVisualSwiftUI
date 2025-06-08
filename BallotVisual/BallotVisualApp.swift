//
//  BallotVisualApp.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI

@main
struct BallotVisualApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: BallotVisualDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
