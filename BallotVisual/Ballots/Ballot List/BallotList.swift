//
//  BallotListView.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/13/25.
//

import SwiftUI
import Balloting
import PDFKit

struct BallotList<E: RankedElectionProtocol>: View  {
    @Binding var election: E
    @Binding var selection: E.Ballot.ID?
    @State var searchText: String = ""
    
    var selectedBallot: Binding<E.Ballot>? {
        $election.projectedValue.ballots.first { $0.id == selection }
    }
    
    var filteredBallots: [E.Ballot] {
        if searchText.isEmpty {
            election.ballots
        } else {
            election.ballots.filter { String(describing: $0.id).localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        Group {
            if election.isRunning {
                if election.ballots.isEmpty {
                    Text("No ballots yet")
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                } else {
                    NavigationSplitView {
                        List(filteredBallots, selection: $selection) { ballot in
                            BallotListElement(ballot: ballot)
                        }
                        .searchable(text: $searchText)
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
                    election.addEmptyBallot(id: UUID() as! E.Ballot.ID, with: election.candidates)
                }) {
                    Image(systemName: "plus")
                }
                .disabled(!election.isRunning)
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    
                }) {
                    Image(systemName: "minus")
                }
                .disabled(selection == nil)
                .disabled(!election.isRunning)
            }
            ToolbarItem(placement: .automatic) {
                let ballotSize = CGSize(width: 400, height: 600)
                
                Button {
                    let renderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ballot.pdf")
                    
                    let ids = self.election.ballots.map(\.id) as [any BallotIdentifiable]
                    let length = max(ids.lengthForUniqueLastCharacters, 5)
                    
                    let ballots = self.election.ballots.compactMap { ballot in
                        PrintableBallotView(
                            title: election.configuration.name,
                            subtitle: election.configuration.detailDescription,
                            ballot: ballot,
                            maxRank: election.candidates.count,
                            idString: ballot.id.truncatedIdentifier(ofLength: length)
                        )
                        .frame(width: ballotSize.width, height: ballotSize.height)
                        .background(.white)
                    }
                    
                    var mediaBox = CGRect(origin: .zero,
                                          size: ballotSize)
                    guard let consumer = CGDataConsumer(url: renderURL as CFURL),
                          let pdfContext =  CGContext(consumer: consumer,
                                                      mediaBox: &mediaBox, nil)
                    else {
                        print("Couldn't get Render consumer")
                        return
                    }
                    
                    for ballot in ballots {
                        let renderer = ImageRenderer(content: ballot)
                        renderer.render { size, renderer in
                            pdfContext.beginPDFPage(nil)
                            pdfContext.translateBy(x: mediaBox.size.width / 2 - size.width / 2,
                                                   y: mediaBox.size.height / 2 - size.height / 2)
                            renderer(pdfContext)
                            pdfContext.endPDFPage()
                        }
                    }
                    
                    pdfContext.closePDF()
                    guard let doc = PDFDocument(url: renderURL),
                          let op = doc.printOperation(for: NSPrintInfo(), scalingMode: .pageScaleDownToFit, autoRotate: false)
                    else {
                        print("Couldn't get document at \(renderURL)")
                        return
                    }
                    op.run()
                    
                } label: {
                    Text("Print Ballots")
                }
                
            }
        }
    }
}

#Preview {
    @Previewable @State var election = RankedElection<Int, ICSOMCandidate>.example
    @Previewable @State var selection: RankedElection<Int, ICSOMCandidate>.Ballot.ID? = nil
    
    BallotList(election: $election, selection: $selection)
}

extension BallotIdentifiable {
    func truncatedIdentifier(ofLength length: Int) -> String {
        let string = String(describing: self)
        return String(string[string.index(string.endIndex, offsetBy: -length)..<string.endIndex])
    }
}

extension Array where Element == any BallotIdentifiable {
    //given this array of strings, what is the length n necessary
    //such that the last n characters of every string are unique
    func humanStrings(ofLength length: Int) -> [String] {
        self.map { id in
            id.truncatedIdentifier(ofLength: length)
        }
    }
    
    var lengthForUniqueLastCharacters: Int {
        var length = 1
        while !humanStrings(ofLength: length).isDistinct {
            length += 1
        }
        return length
    }
}

extension Sequence where Element: Hashable {
    /// Returns true if no element is equal to any other element.
    var isDistinct: Bool {
        var set = Set<Element>()
        for e in self {
            if set.insert(e).inserted == false { return false }
        }
        return true
    }
}
