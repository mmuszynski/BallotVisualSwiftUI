//
//  CandidateInspector.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 8/13/25.
//

import Balloting
import SwiftUI

struct CandidateInspector: View {
    var candidate: Binding<ICSOMCandidate>?
    @Binding var selection: ICSOMCandidate.ID?

    var body: some View {
        if let candidate {
            Form {
                TextField("Candidate Name", text: candidate.name)
                
                LabeledContent {
                    VStack(alignment: .leading) {
                        Text(String(describing: candidate.wrappedValue.id))
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                candidate.wrappedValue.id = UUID()
                                selection = candidate.wrappedValue.id
                            }) {
                                Text("Regenerate")
                            }
                        }
                    }
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
