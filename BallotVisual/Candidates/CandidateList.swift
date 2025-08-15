//
//  CandidatesView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/9/25.
//

import SwiftUI
import Balloting

struct CandidateList<BallotID: BallotIdentifiable, CandidateType: Candidate>: View {
    @Binding var election: RankedElection<BallotID, CandidateType>
    @Binding var selection: CandidateType.ID?
        
    @State var isDeletingCandidate: Bool = false
    
    var selectedCandidate: Binding<CandidateType>? {
        $election.projectedValue.candidates.first { $0.id == selection }
    }
    
    var body: some View {
        NavigationSplitView {
            List(election.candidates, selection: $selection) { candidate in
                HStack {
                    Image(systemName: "person.circle")
                        .imageScale(.large)
                    VStack(alignment: .leading) {
                        Text(candidate.name)
                        Text(String(describing: candidate.id))
                            .font(.footnote)
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        } detail: {
            CandidateInspector(candidate: selectedCandidate,
                               selection: $selection)
            .navigationSplitViewColumnWidth(min: 400, ideal: 400, max: 600)
        }.toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    election.candidates.append(CandidateType(name: "New Candidate"))
                    selection = election.candidates.last?.id
                }, label: {
                    Image(systemName: "plus")
                })
                .disabled(election.isRunning)
                .help(election.isRunning ? "Cannot add or delete candidates if the election is currently running." : "Add a new candidate.")
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    isDeletingCandidate = true
                }, label: {
                    Image(systemName: "minus")
                })
                .disabled(selection == nil || election.isRunning)
                .help(election.isRunning ? "Cannot add or delete candidates if the election is currently running." : "Delete the selected candidate.")
            }
        }
        .alert("Delete \(selectedCandidate?.wrappedValue.name ?? "Candidate")?",
               isPresented: $isDeletingCandidate,
               actions: {
            Button("Delete", role: .destructive) {
                election.candidates.removeAll { $0.id == selection! }
                isDeletingCandidate = false
            }
        }, message: {
            Text("Are you sure you want to delete \(selectedCandidate?.wrappedValue.name ?? "the selected candidate")?")
        })
        .dialogSeverity(.critical)
    }
}

#Preview {
    @Previewable @State var election = RankedElection<Int, ICSOMCandidate>.example
    @Previewable @State var selection: ICSOMCandidate.ID? = nil
    
    CandidateList(election: $election, selection: $selection)
}
