//
//  CheckboxRankingPicker.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 7/26/25.
//

import SwiftUI
import Balloting

struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 30, height: 30)
            .background(.quaternary, in: Rectangle())
            .border(.black, width: 2)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CheckboxBallotEditor<B: RankedBallotProtocol>: View {
    @Binding var ballot: B
    var maxRank: Int
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                ForEach(1...maxRank, id: \.self) { rank in
                    Text("\(rank)")
                        .frame(width: 30)
                }
            }
            ForEach($ballot.rankings) { $ranking in
                CheckboxRankingPicker(maxRanking: maxRank, ranking: $ranking)
            }
        }
    }
}

struct CheckboxRankingPicker<C: Candidate>: View {
    var maxRanking: Int
    @Binding var ranking: CandidateRanking<C>
    
    var body: some View {
        HStack {
            Text(ranking.candidate.name)
            Spacer()
            ForEach(1...maxRanking, id: \.self) { index in
                Button {
                    ranking.rank = ranking.rank == index ? nil : index
                } label: {
                    Image(systemName: "checkmark")
                        .opacity(ranking.rank == index ? 1 : 0)
                }
            }
            .buttonStyle(CheckboxButtonStyle())
        }
    }
}

#Preview {
    @Previewable
    @State
    var ballot = RankedElection<UUID, ICSOMCandidate>.Ballot(id: UUID(), rankings: [
        .init(candidate: .init(id: UUID(), name: "Joe Smith"), rank: nil),
        .init(candidate: .init(id: UUID(), name: "Joe Smith"), rank: nil),
        .init(candidate: .init(id: UUID(), name: "Joe Smith"), rank: nil)
    ])
    
    CheckboxBallotEditor(ballot: $ballot, maxRank: 5)
}
