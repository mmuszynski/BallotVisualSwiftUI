//
//  BallotBreakdownView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/20/25.
//

import SwiftUI
import Balloting

extension RankedBallot {
    subscript(_ candidate: C) -> String {
        return String(self[candidate]?.rank ?? 0)
    }
}

struct BallotBreakdownView<B: BallotIdentifiable, C: Candidate>: View {
    var ballots: [RankedBallot<B, C>]
    var candidates: [C] {
        ballots.first?.rankings.map(\.candidate) ?? []
    }
    var body: some View {
        GeometryReader { g in
            List {
                Section {
                    ForEach(ballots) { ballot in
                        HStack {
                            Text(ballot.id.stringValue)
                                .frame(width: 40)
                            ForEach(candidates) { candidate in
                                Text(ballot[candidate])
                                    .frame(width: g.size.width / CGFloat(candidates.count + 1))
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("ID")
                            .frame(width: 40)
                        ForEach(candidates) { candidate in
                            Text(candidate.name)
                                .frame(width: g.size.width / CGFloat(candidates.count + 1))
                        }
                    }
                }
            }
        }
//                Table(ballots) {
//                    TableColumn("id", value: \.id.stringValue)
//                    TableColumnForEach(candidates) { candidate in
//                        TableColumn(candidate.name, value: \.self[candidate])
//                    }
//                }
    }
}

#Preview {
    BallotBreakdownView(ballots: RankedElection<Int, ICSOMCandidate>.example.ballots)
}
