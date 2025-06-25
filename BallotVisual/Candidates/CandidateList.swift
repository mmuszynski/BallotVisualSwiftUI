//
//  CandidatesView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/9/25.
//

import SwiftUI
import Balloting

struct CandidateList: View {
    @Binding var election: Election
    @Binding var selection: ICSOMCandidate.ID?
    
    @State var isDeletingCandidate: Bool = false
    
    var selectedCandidate: Binding<ICSOMCandidate>? {
        $election.projectedValue.candidates.first { $0.id == selection }
    }
    
    var body: some View {
        GeometryReader { g in
            HSplitView {
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
                .listStyle(SidebarListStyle())
                .frame(height: g.size.height)
                .frame(minWidth: 150, maxWidth: .infinity)
                
                CandidateInspector(candidate: selectedCandidate,
                                   selection: $selection)
                .formStyle(GroupedFormStyle())
                .frame(height: g.size.height)
                .frame(minWidth: 400, maxWidth: .infinity)
            }
        }
        .frame(minWidth: 550)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    election.candidates.append("New Candidate")
                }, label: {
                    Image(systemName: "plus")
                })
                .disabled(election.isCurrentlyRunning)
                .help(election.isCurrentlyRunning ? "Cannot add or delete candidates if the election is currently running." : "Add a new candidate.")
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    isDeletingCandidate = true
                }, label: {
                    Image(systemName: "minus")
                })
                .disabled(selection == nil || election.isCurrentlyRunning)
                .help(election.isCurrentlyRunning ? "Cannot add or delete candidates if the election is currently running." : "Delete the selected candidate.")
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
        } else {
            Text("No candidate selected")
        }
    }
}

#Preview {
    @Previewable @State var election: Election = Election.example
    @Previewable @State var selection: ICSOMCandidate.ID? = nil
    
    CandidateList(election: $election, selection: $selection)
}
