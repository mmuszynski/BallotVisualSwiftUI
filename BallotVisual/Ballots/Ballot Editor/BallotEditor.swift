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
        case checkbox
    }
    
    var ballot: Binding<Election.Ballot>?
    var maxRank: Int
    @Environment(\.ballotEditorStyle) var pickerStyle
    
    var body: some View {
        if let ballot {
            VStack(alignment: .leading) {
                HStack {
                    Text("Ballot")
                    if ballot.wrappedValue.isValid == false {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                }
                .font(.title)
                
                Text("id: \(ballot.id)")
                    .font(.title2)
                    .padding(.bottom)
                
                switch pickerStyle {
                case .menu:
                    MenuBallotEditor(ballot: ballot, maxRank: maxRank)
                case .segmented:
                    SegmentedBallotEditor(ballot: ballot, maxRank: maxRank)
                case .checkbox:
                    CheckboxBallotEditor(ballot: ballot, maxRank: maxRank)
                }
                
                Spacer()
            }
        } else {
            Text("No ballot selected")
                .foregroundStyle(.tertiary)
        }
    }
}

private struct PickerBasedBallotEditor: View {
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
        PickerBasedBallotEditor(ballot: $ballot, maxRank: maxRank, imageBased: true)
            .pickerStyle(.segmented)
    }
}

private struct MenuBallotEditor: View {
    @Binding var ballot: Election.Ballot
    var maxRank: Int
    
    var body: some View {
        PickerBasedBallotEditor(ballot: $ballot, maxRank: maxRank)
            .pickerStyle(.menu)
    }
}

private struct CheckboxBallotEditor: View {
    @Binding var ballot: Election.Ballot
    var maxRank: Int
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                ForEach(1...maxRank, id: \.self) { rank in
                    Text("\(rank)")
                        .frame(width: 30)
                }
                Text("")
                    .frame(width: 30)
            }
            ForEach($ballot.rankings) { $ranking in
                CheckboxRankingPicker(maxRanking: maxRank, ranking: $ranking)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedBallotID: Int?
    @Previewable @State var document = ElectionDocument.example

    BallotList(election: $document.election,
               selection: $selectedBallotID)
}
