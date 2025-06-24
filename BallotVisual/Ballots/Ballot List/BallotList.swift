//
//  BallotListView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/13/25.
//

import SwiftUI
import Balloting

struct BallotList: View {
    var ballots: [Election.Ballot]
    @Binding var selectedBallotID: Int?
        
    var body: some View {
        HStack {
            List(ballots, selection: $selectedBallotID) { ballot in
                BallotListElement(ballot: ballot)
                    .onChange(of: ballot) { oldValue, newValue in
                        print(ballot)
                    }
            }
        }
    }
}
