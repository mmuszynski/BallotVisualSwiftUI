//
//  ContentView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI
import Balloting

struct ContentView: View {
    typealias DocumentType = ElectionDocument<UUID, ICSOMCandidate>
    
    @Binding var document: DocumentType
    @State var selectedSection: TabSection = .information
    
    @State var selectedBallotID: DocumentType.ElectionType.Ballot.ID?
    @State var selectedCandidate: ICSOMCandidate.ID?
    
    enum TabSection: String, Identifiable, CaseIterable {
        case information
        case candidates
        case ballots
        case results
        
        var id: TabSection { self }
        
        var systemImageName: String {
            switch self {
            case .information:
                return "info.circle"
            case .ballots:
                return "list.number"
            case .candidates:
                return "person.3.sequence.fill"
            case .results:
                return "trophy"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedSection) {
            ForEach(TabSection.allCases) { section in
                Tab(section.rawValue.capitalized, systemImage: section.systemImageName, value: section) {
                    switch section {
                    case .information:
                        ElectionInformation(election: $document.election)
                    case .ballots:
                        BallotList(election: $document.election,
                                   selection: $selectedBallotID)
                    case .candidates:
                        CandidateList(election: $document.election,
                                      selection: $selectedCandidate)
                    case .results:
                        Text("Results")
                    }
                }
                
                
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        
    }
}

#Preview {
    @Previewable @State var document = ElectionDocument<UUID, ICSOMCandidate>.example
    ContentView(document: $document)
}
