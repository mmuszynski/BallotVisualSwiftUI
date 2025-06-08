//
//  ContentView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: BallotVisualDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(BallotVisualDocument()))
}
