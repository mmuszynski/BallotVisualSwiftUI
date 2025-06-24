//
//  CandidatesView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/9/25.
//

import SwiftUI
import Balloting

struct CandidatesView: View {
    @Binding var election: RankedElection<Int, String>
    
    var body: some View {
        Text("Candidates")
    }
}
