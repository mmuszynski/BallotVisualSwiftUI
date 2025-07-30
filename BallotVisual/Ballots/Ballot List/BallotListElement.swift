//
//  BallotListElementView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/24/25.
//

import SwiftUI
import Balloting

struct BallotListElement: View {
    var ballot: any RankedBallotProtocol
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("id: \(ballot.id)")
                Text(ballot.textualDescription)
            }
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
                .opacity(ballot.isValid ? 0 : 1)
        }
    }
}


#Preview {
    BallotListElement(ballot: Election.Ballot.example)
}
