//
//  BallotVisualDocument.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/8/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Balloting

typealias Election = RankedElection<Int, ICSOMCandidate>

extension UTType {
    static var rankedChoiceElection: UTType {
        UTType(importedAs: "org.icsom.balloting.electionDocument")
    }
}

struct ElectionDocument: FileDocument {
    var election: Election
    
    static var readableContentTypes: [UTType] { [.rankedChoiceElection] }
    
    init () {
        self.election = Election(ballots: [])
    }
    
    init(election: Election) {
        self.election = election
    }
    
    init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
                
        guard
            let wrappers = configuration.file.fileWrappers,
            let configurationFile = wrappers["configuration.json"],
            let ballotFile = wrappers["ballots.csv"],
            let candidatesFile = wrappers["candidates.json"]
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        guard
            let ballotCSV = ballotFile.regularFileContents,
            let configurationData = configurationFile.regularFileContents,
            let candidatesData = candidatesFile.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        let candidates = try decoder.decode(Array<ICSOMCandidate>.self, from: candidatesData)
        
        guard let ballotCSVString = String(data: ballotCSV, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }

        self.election = try Election(csvRepresentation: ballotCSVString)
        self.election.candidates = candidates
        self.election.configuration = try decoder.decode(ElectionConfiguration.self, from: configurationData)
        
//        //Add nil for unranked candidates for this election type
//        let candidates = election.candidates
//        var ballots = Set<Election.Ballot>()
//        for ballot in election.ballots.sorted() {
//            ballots.insert(RankedBallot(id: ballot.id, rankings: candidates.map {
//                RankedBallot.CandidateRanking(candidate: $0, rank: ballot[$0]?.rank)
//            }))
//        }
//        
//        election.ballots = Array(ballots).sorted()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        //let's make this into a csv with votes and an election file
        guard let csv = election.csvRepresentation().data(using: .utf8) else {
            throw CocoaError(.fileWriteUnknown)
        }
        
        let config = try JSONEncoder().encode(election.configuration)
        let candidates = try JSONEncoder().encode(election.candidates)
        
        let csvFile = FileWrapper(regularFileWithContents: csv)
        let configFile = FileWrapper(regularFileWithContents: config)
        let candidatesFile = FileWrapper(regularFileWithContents: candidates)
        
        let directory = FileWrapper(directoryWithFileWrappers: ["configuration.json" : configFile, "ballots.csv" : csvFile, "candidates.json" : candidatesFile])
        return directory
    }
}
