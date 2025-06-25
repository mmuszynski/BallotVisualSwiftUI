//
//  BallotsView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/9/25.
//

import SwiftUI
import Balloting

struct BallotCardsView: View {
    var ballot: RankedElection<Int, String>.Ballot
    @State private var dropTarget: String?

    var body: some View {
        ForEach(ballot.sortedByRank()) { ranking in
            HStack {
                Text("\(ranking.rank!)")
                    .font(.largeTitle)
                Spacer()
                Text(ranking.candidate)
                    .font(.headline)
            }
            .frame(width: 200)
            .padding()
            .border(dropTarget == ranking.candidate ? AnyShapeStyle(.selection) : AnyShapeStyle(.secondary))
            .contentShape(Rectangle())
            .draggable(ranking.candidate)
            .dropDestination(for: String.self) { items, location in
                dropTarget = nil
                return true
            } isTargeted: { target in
                dropTarget = ranking.candidate
            }
        }
    }
}

#Preview {
    @Previewable @State var document = ElectionDocument.example
    @Previewable @State var selectedBallot: Election.Ballot.ID?
    
    NavigationSplitView {
        BallotList(election: $document.election,
                   selection: $selectedBallot)
    } detail: {
        
    }
}
