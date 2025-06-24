//
//  OldVersion.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/13/25.
//

import SwiftUI

struct OldVersion: View {
    @Binding var document: ElectionDocument

    var body: some View {
        TabView {
            Tab("Ballots", systemImage: "menucard") {
                BallotsView(document: $document)
            }
            
            Tab {
                Text("Candidates")
            } label: {
                Text("Candidates")
            }
        }
    }
}

struct BallotsView: View {
    @Binding var document: ElectionDocument
        
    var body: some View {
        NavigationSplitView {
            List($document.ballots) { $ballot in
                NavigationLink {
                    BallotEditor(ballot: $ballot, maxRank: document.election.candidates.count)
                        .padding()
                } label: {
                    BallotListElement(ballot: ballot)
                }
            }
        } detail: {
            
        }
    }
}

#Preview {
    @Previewable @State var document: ElectionDocument = .example
    
    OldVersion(document: $document)
}
