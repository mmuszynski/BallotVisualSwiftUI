//
//  BallotEditor.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/10/25.
//

import SwiftUI
import Balloting

extension EnvironmentValues {
    @Entry var ballotEditorStyle = BallotEditorStyle.menu
}

extension View {
    func ballotEditorStyle(_ ballotEditorStyle: BallotEditorStyle) -> some View {
        self
            .environment(\.ballotEditorStyle, ballotEditorStyle)
    }
}

enum BallotEditorStyle {
    case menu
    case segmented
    case checkbox
}

struct BallotEditor<B: RankedBallotProtocol>: View {
    
    var ballot: Binding<B>?
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

private struct PickerBasedBallotEditor<B: RankedBallotProtocol>: View {
    @Binding var ballot: B
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

private struct SegmentedBallotEditor<B: RankedBallotProtocol>: View {
    @Binding var ballot: B
    var maxRank: Int
    
    var body: some View {
        PickerBasedBallotEditor(ballot: $ballot, maxRank: maxRank, imageBased: true)
            .pickerStyle(.segmented)
    }
}

private struct MenuBallotEditor<B: RankedBallotProtocol>: View {
    @Binding var ballot: B
    var maxRank: Int
    
    var body: some View {
        PickerBasedBallotEditor(ballot: $ballot, maxRank: maxRank)
            .pickerStyle(.menu)
    }
}

#Preview {
    @Previewable @State var selectedBallotID: UUID?
    @Previewable @State var document = ElectionDocument.example

    BallotList(election: $document.election,
               selection: $selectedBallotID)
}
