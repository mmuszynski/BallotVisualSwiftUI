//
//  CandidateRankingPicker.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/10/25.
//

import SwiftUI
import Balloting

struct CandidateRankingPicker<C: Candidate>: View {
    var maxRanking: Int
    @Binding var ranking: CandidateRanking<C>
    var imageBased: Bool = false
    
    var body: some View {
        Picker(ranking.candidate.name, selection: $ranking.rank) {
            Group {
                if self.imageBased {
                    Image(systemName: "xmark.circle.fill")
                } else {
                    Text("No preference")
                }
            }
            .tag(Optional<Int>(nil))
            
            ForEach(1...maxRanking, id: \.self) { index in
                Text("\(index)")
                    .tag(index)
            }
        }
    }
}

#Preview {
    @Previewable @State var jeff = CandidateRanking<ICSOMCandidate>(candidate: "Jeff", rank: nil)
    @Previewable @State var stephen = CandidateRanking<ICSOMCandidate>(candidate: "Stephen", rank: nil)
    @Previewable @State var maria = CandidateRanking<ICSOMCandidate>(candidate: "Maria", rank: nil)
    @Previewable @State var claire = CandidateRanking<ICSOMCandidate>(candidate: "Claire", rank: nil)
    
    Form {
        CandidateRankingPicker(maxRanking: 5, ranking: $jeff)
        CandidateRankingPicker(maxRanking: 5, ranking: $stephen)
        CandidateRankingPicker(maxRanking: 5, ranking: $maria)
        CandidateRankingPicker(maxRanking: 5, ranking: $claire)
    }
    .frame(width: 400)
    .pickerStyle(.segmented)
}
