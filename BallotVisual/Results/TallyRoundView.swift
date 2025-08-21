//
//  TallyRoundView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/20/25.
//

import SwiftUI
import Balloting

struct TallyRoundView<B: BallotIdentifiable, C: Candidate>: View {
    var round: IRVRound<B, C>
    
    init(_ round: IRVRound<B, C>) {
        self.round = round
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(round.finalTally) { tally in
                HStack {
                    Text("\(tally.candidate.name)")
                    Spacer()
                    Text("\(tally.votes)")
                }
            }
            Text("")
            Text("MajorityCandidate:")
            Text("\(round.majorityCandidate?.name ?? "None")")
            Text("Eliminated Candidate:")
            Text("\(round.eliminatedCandidate?.name ?? "None")")
        }
    }
}

#Preview {
    TallyRoundView(IRVRound<Int, ICSOMCandidate>.example)
}
