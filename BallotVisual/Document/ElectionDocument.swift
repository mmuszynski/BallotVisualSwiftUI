//
//  BallotVisualDocument.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Balloting

typealias Election = RankedElection<Int, String>

extension UTType {
    static var rankedChoiceElection: UTType {
        UTType(importedAs: "org.icsom.balloting.rankedChoiceElection")
    }
}

struct ElectionDocument: FileDocument {
    var election: Election
    var ballots: [Election.Ballot]

    static var readableContentTypes: [UTType] { [.rankedChoiceElection] }
    
    init () {
        self.election = Election(ballots: [])
        self.ballots = []
    }
    
    init(election: Election) {
        self.election = election
        self.ballots = election.ballots.sorted()
    }

    init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        var election = try decoder.decode(Election.self, from: data)
        self.election = election
        
        //Add nil for unranked candidates for this election type
        let candidates = election.candidates
        var ballots = Set<Election.Ballot>()
        for ballot in election.ballots.sorted() {
            ballots.insert(RankedBallot(id: ballot.id, rankings: candidates.map {
                RankedBallot.CandidateRanking(candidate: $0, rank: ballot[$0]?.rank)
            }))
        }

        election.ballots = ballots
        self.ballots = election.ballots.sorted()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let json = try JSONEncoder().encode(self.election)
        return .init(regularFileWithContents: json)
    }
}
