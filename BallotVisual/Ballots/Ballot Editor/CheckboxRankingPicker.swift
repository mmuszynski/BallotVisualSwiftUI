//
//  CheckboxRankingPicker.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 7/26/25.
//

import SwiftUI

struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 30, height: 30)
            .background(.quaternary, in: Rectangle())
            .border(.black, width: 2)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 30, height: 30)
            .background(.quaternary, in: Circle())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CheckboxRankingPicker: View {
    var maxRanking: Int
    @Binding var ranking: Election.Ballot.CandidateRanking
    
    var body: some View {
        HStack {
            Text(ranking.candidate.name)
            Spacer()
            ForEach(1...maxRanking, id: \.self) { index in
                Button {
                    ranking.rank = index
                } label: {
                    Image(systemName: "checkmark")
                        .opacity(ranking.rank == index ? 1 : 0)
                }
            }
            .buttonStyle(CheckboxButtonStyle())
            
            //Clear button
            Button {
                ranking.rank = nil
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(ClearButtonStyle())
        }
    }
}

#Preview {
    @Previewable
    @State
    var ranking = Election.Ballot.CandidateRanking(candidate: .init(name: "Test"))
    
    CheckboxRankingPicker(maxRanking: 5, ranking: $ranking)
}
