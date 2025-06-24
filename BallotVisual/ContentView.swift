//
//  ContentView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI
import Balloting

extension Binding where Value == ElectionDocument {
    func binding(for selection: Election.Ballot.ID) -> Binding<Election.Ballot>? {
        self.projectedValue.ballots.first {
            $0.wrappedValue.id == selection
        }
    }
}

struct ContentView: View {
    @Binding var document: ElectionDocument
    @AppStorage("com.mmuszynski.BallotVisual.selectedSection")
    var selectedSection: Section = .ballots
    @State var selectedBallotID: Election.Ballot.ID?
    @State var appState: AppState = .init()
    
    enum Section: String, Identifiable, CaseIterable {
        case information
        case ballots
        case candidates
        
        var id: Section { self }
        
        var systemImageName: String {
            switch self {
            case .information:
                return "info.circle"
            case .ballots:
                return "list.number"
            case .candidates:
                return "person.3.sequence.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedSection) {
            ForEach(Section.allCases) { section in
                Tab(section.rawValue.capitalized, systemImage: section.systemImageName, value: section) {
                    switch section {
                    case .information:
                        Text("Information")
                    case .ballots:
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
                        
                    case .candidates:
                        Text("Candidates")
                    }
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        
    }
}

#Preview {
    @Previewable @State var document: ElectionDocument = .example
    ContentView(document: $document)
}
