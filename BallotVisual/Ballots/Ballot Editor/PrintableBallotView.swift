//
//  PrintableBallotView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/14/25.
//

import SwiftUI
import Balloting

struct BulletedText: View {
    var text: String
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .imageScale(.small)
            Text(text)
        }
    }
}

struct PrintableBallotView<B: RankedBallotProtocol>: View {
    var title: String
    var subtitle: String?
    var ballot: B
    var maxRank: Int
    var idString: String?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            
            if let subtitle {
                Text(subtitle)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                BulletedText("Rank each candidate in order of preference (where 1 represents MOST preferred and \(maxRank) represents LEAST preferred)")
                BulletedText("Mark no more than one box per candidate row")
                BulletedText("Leave the row blank if you do not wish to support a given candidate")
            }
            .padding()
            .padding(.bottom, 20)
            
            CheckboxBallotEditor(ballot: .constant(ballot), maxRank: maxRank)
                .foregroundStyle(.black)
            Spacer()
    
            HStack {
                Spacer()
                Text("id: " + (idString ?? String(describing: ballot.id)))
                    .padding(.bottom)
            }
        }
        .backgroundStyle(.white)
        .padding()
    }
}

#Preview("Printed Version", traits: .fixedLayout(width: 400, height: 600)) {
    @Previewable @State var selectedBallotID: UUID?
    @Previewable @State var document = ElectionDocument<UUID, ICSOMCandidate>.example
    PrintableBallotView(
        title: "Example Ballot",
        subtitle: "August 14, 2025",
        ballot: document.election.ballots.first!,
        maxRank: 5
    )
}
