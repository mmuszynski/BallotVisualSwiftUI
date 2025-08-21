//
//  ResultsView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/20/25.
//

import SwiftUI
import Balloting

struct ResultsView<B: BallotIdentifiable, C: Candidate>: View {
    @State var selection: Int = 0
    var election: RankedElection<B, C>
    
    @State var tallyRounds: [IRVRound<B, C>] = []
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Text("Ballots")
                    .tag(0)
                ForEach(0..<tallyRounds.count, id: \.self) { id in
                    Text("Round \(id + 1)")
                        .tag(id + 1)
                }
            }
        } detail: {
            switch selection {
            case 0:
                BallotBreakdownView(ballots: election.ballots)
            default:
                let id = selection - 1
                if id >= tallyRounds.count {
                    EmptyView()
                } else {
                    TallyRoundView(tallyRounds[selection - 1])
                        .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    //new tally
                    do {
                        tallyRounds.append(
                        try IRVRound(ballots: Set(election.ballots),
                                     candidates: Set(election.candidates),
                                     ignoring: Set(tallyRounds.compactMap(\.eliminatedCandidate)),
                                     breakingTiesWith: [])
                        )
                    } catch {
                        print("Couldn't tally with \(error)")
                    }
                } label: {
                    Text("Tally")
                }
            }
        }
    }
}

#Preview {
    ResultsView(election: RankedElection<Int, ICSOMCandidate>.example)
}
