//
//  ElectionInformation.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/24/25.
//

import SwiftUI
import Balloting

struct ElectionInformation: View {
    @Binding var election: Election
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $election.configuration.name)
                TextField("Description", text: $election.configuration.detailDescription)
            }
            
            Section {
                DatePicker("Start Date", selection: $election.configuration.beginDate)
                
                HStack {
                    Spacer()
                    Button("Begin Election") {
                        election.configuration.beginDate = Date()
                    }
                }
                
            } header: {
                Text("Date/Time")
            } footer: {
                Text("The election will only allow modifications to the candidate list prior to the start date. Supply a start time in order to automatically begin.")
            }
            
            Section {
                Text("\(election.candidates.count) candidates")
                Text("Status: \(election.isCurrentlyRunning ? "Running" : "Preparing")")
            }
        }
        .formStyle(GroupedFormStyle())
    }
}

#Preview {
    @Previewable @State var election: Election = .example
    ElectionInformation(election: $election)
}
