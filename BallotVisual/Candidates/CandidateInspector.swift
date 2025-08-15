//
//  CandidateInspector.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/13/25.
//

import Balloting
import SwiftUI

struct CandidateInspector<C: Candidate>: View {
    var candidate: Binding<C>?
    @Binding var selection: C.ID?

    var body: some View {
        if let candidate {
            Form {
                TextField("Candidate Name", text: candidate.name)
                
                LabeledContent {
                    Text(String(describing: candidate.wrappedValue.id))
                } label: {
                    Text("Candidate ID")
                }
            }
            .formStyle(GroupedFormStyle())
        } else {
            Text("No candidate selected")
        }
    }
}
