//
//  BallotListView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/13/25.
//

import SwiftUI
import Balloting

struct BallotList: View {
    @Binding var election: Election
    @Binding var selection: Election.Ballot.ID?
    
    var selectedBallot: Binding<Election.Ballot>? {
        $election.projectedValue.ballots.first { $0.id == selection }
    }
        
    var body: some View {
        Group {
            if election.isCurrentlyRunning {
                if election.ballots.isEmpty {
                    Text("No ballots yet")
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                } else {
                    NavigationSplitView {
                        List(election.ballots, selection: $selection) { ballot in
                            BallotListElement(ballot: ballot)
                        }
                    } detail: {
                        BallotEditor(ballot: selectedBallot, maxRank: election.candidates.count)
                            .ballotEditorStyle(.checkbox)
                            .padding()
                    }
                }
            } else {
                VStack {
                    Text("Election pending")
                        .font(.largeTitle)
                        .padding()
                    Text("Ballots are not available until the election has started")
                        .font(.title3)
                }
                .foregroundStyle(.tertiary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    election.addEmptyBallot(id: election.ballots.count, with: election.candidates)
                }) {
                    Image(systemName: "plus")
                }
                .disabled(!election.isCurrentlyRunning)
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    election.addEmptyBallot(id: election.ballots.count, with: election.candidates)
                }) {
                    Image(systemName: "minus")
                }
                .disabled(selection == nil)
                .disabled(!election.isCurrentlyRunning)
            }
        }
    }
}

#Preview {
    @Previewable @State var election: Election = Election.example
    @Previewable @State var selection: Election.Ballot.ID? = nil
    
    BallotList(election: $election, selection: $selection)
}

/*
 BallotList(ballots: document.ballots,
            selectedBallotID: $selectedBallotID)
 .listStyle(.sidebar)
 .inspector(isPresented: .constant(true)) {
     Group {
         if let id = selectedBallotID {
             BallotEditor(ballot: $document.binding(for: id),
                          maxRank: document.election.candidates.count)
         } else {
             Text("Select a ballot")
         }
     }
     .inspectorColumnWidth(min: 400, ideal: 800, max: nil)
 }
 */
