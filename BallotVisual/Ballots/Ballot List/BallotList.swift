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
                Button {
                    let renderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ballot.pdf")
                    
                    let ballots = self.election.ballots.compactMap { ballot in
                        BallotEditor(ballot: .constant(ballot), maxRank: election.candidates.count)
                            .frame(width: 400, height: 400)
                            .border(.black)
                            .ballotEditorStyle(.checkbox)
                    }
                    
                    var mediaBox = CGRect(origin: .zero,
                                          size: CGSize(width: 800, height: 600))
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
                          let op = doc.printOperation(for: NSPrintInfo(), scalingMode: .pageScaleNone, autoRotate: false)
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
