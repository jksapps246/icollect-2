//
//  Sharing.swift
//  icollect
//
//  Created by user231414 on 3/11/23.
//
import PDFKit
import UIKit
import AVFoundation
import SQLite

class Sharing: UIViewController, PDFViewDelegate {
    var selectedCollection: Collection!
    let pdfV = PDFView()
    public var documentData: Data?
    var imageSets: [imageSet] = []

    @IBOutlet weak var pdfView: UIView!
    
    var database: Connection!
    let sTable = Table("singleCollectionList")
    let sImage = Expression<Data?>("image")
    let cId = Expression<Int>("cId")
    let sName = Expression<String?>("name")
    //var singleCollectionImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView.addSubview(pdfV)
        pdfV.delegate = self
        conectToDatabase()
        getCollection()
        
        //create design
        let pdfCreator = PDFDesign(
            title: selectedCollection.name,
            body: selectedCollection.description,
            image: UIImage(data: selectedCollection.image)!,
            imageSet: imageSets
        )
            documentData = pdfCreator.createFlyer()

        if let data = documentData {
          pdfV.document = PDFDocument(data: data)
          pdfV.autoScales = true
        }        
    }
    //MARK: Connect To Database
    func conectToDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("icDb").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    //MARK: Get Collection
    private func getCollection(){
        do{
            let filteredTable = self.sTable.filter(self.cId == selectedCollection.id)
            let collectionDB = try self.database.prepare(filteredTable)
            for colls in collectionDB {
                if colls[self.sImage] != nil {
                    imageSets.append(imageSet(
                        name: colls[self.sName]!,
                        image: UIImage(data: colls[self.sImage]!)!
                    ))
                }
            }
        }catch {
            print(error)
        }
    }
    override func viewDidLayoutSubviews() {
        //.viewDidLayoutSubviews()
        pdfV.frame = pdfView.bounds
    }
    //MARK: Share Collection
    @IBAction func shareWith(_ sender: Any) {
        let pdfCreator = PDFDesign(
            title: selectedCollection.name,
            body: selectedCollection.description,
            image: UIImage(data: selectedCollection.image)!,
            imageSet: imageSets
        )
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(
          activityItems: [pdfData],
          applicationActivities: []
        )
        present(vc, animated: true, completion: nil)        
    }
}
struct imageSet {
    let name: String
    let image: UIImage
}
