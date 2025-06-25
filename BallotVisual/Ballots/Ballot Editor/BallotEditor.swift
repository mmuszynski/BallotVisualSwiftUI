//
//  BallotEditor.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/10/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var ballotEditorStyle = BallotEditor.Style.menu
}

extension View {
    func ballotEditorStyle(_ ballotEditorStyle: BallotEditor.Style) -> some View {
        self
            .environment(\.ballotEditorStyle, ballotEditorStyle)
    }
}

struct BallotEditor: View {
    enum Style {
        case menu
        case segmented
    }
    
    var ballot: Binding<Election.Ballot>?
    var maxRank: Int
    @Environment(\.ballotEditorStyle) var pickerStyle
    
    var body: some View {
        if let ballot {
            VStack {
                HStack {
                    Text("Ballot: \(ballot.id)")
                    if ballot.wrappedValue.isValid == false {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                }
                .font(.title)
                .padding(.top)
                if pickerStyle == .menu {
                    MenuBallotEditor(ballot: ballot, maxRank: maxRank)
                } else {
                    SegmentedBallotEditor(ballot: ballot, maxRank: maxRank)
                }
            }
        } else {
            Text("No ballot selected")
                .foregroundStyle(.tertiary)
        }
    }
}

private struct ConcreteBallotEditor: View {
    @Binding var ballot: Election.Ballot
    var maxRank: Int
    var imageBased: Bool = false
    
    var body: some View {
        Form {
            ForEach($ballot.rankings) { $ranking in
                CandidateRankingPicker(maxRanking: maxRank, ranking: $ranking, imageBased: imageBased)
            }
        }
    }
}

private struct SegmentedBallotEditor: View {
    @Binding var ballot: Election.Ballot
    var maxRank: Int
    
    var body: some View {
        ConcreteBallotEditor(ballot: $ballot, maxRank: maxRank, imageBased: true)
            .pickerStyle(.segmented)
    }
}

private struct MenuBallotEditor: View {
    @Binding var ballot: Election.Ballot
    var maxRank: Int
    
    var body: some View {
        ConcreteBallotEditor(ballot: $ballot, maxRank: maxRank)
            .pickerStyle(.menu)
    }
}

#Preview {
    @Previewable @State var selectedBallotID: Int?
    @Previewable @State var document = ElectionDocument.example

    BallotList(election: $document.election,
               selection: $selectedBallotID)
}
