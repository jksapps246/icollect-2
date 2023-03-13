//
//  AddToCollection.swift
//  icollect
//
//  Created by user231414 on 2/25/23.
//

import UIKit


class AddToCollection: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let db = DBHelper()
    
    var selectedSingleId: Int!
    var selectedSingleCollection: singleCollection!
    var selectedCollection: Collection!
    var sCollections: [singleCollection] = []
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!    
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var toast: Toast! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toast = Toast(view: view)
        
        //connect to database file
        db.conectToDatabase()
        
        //create collection table
        db.createSingleCollectionTable()
        //fill all fields if the action is edit
        if selectedSingleCollection != nil {
            image.image = UIImage(data: selectedSingleCollection.image)
            name.text = selectedSingleCollection.name
            desc.text = selectedSingleCollection.description
            saveButton.setTitle("Update", for: .normal)
        }
    }
   
    //MARK: Add Image Button
    @IBAction func addImage(_ sender: Any) {
        let userImage = UIImagePickerController()
        userImage.delegate = self
        userImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        userImage.allowsEditing = false
        self.present(userImage, animated: true){
            //After it is complted
        }
    }
    //MARK: Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image.contentMode = .scaleAspectFit
                image.image = userImage
            }
        else {
            toast.showToast(message: "Error: Cannot Load Image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Image Picker Controller - Canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    //MARK: Save and Update
    @IBAction func save(_ sender: Any) {

        if name.text == "" {
            toast.showToast(message: "Missing Name")
        }
        else if desc.text == "" {
            toast.showToast(message: "Missing Description")
        }
        else {
            
                //add to database
                let img : UIImage = image.image!
                if saveButton.title(for: .normal) == "Update" {
                    //update data
                    db.updateSingleCollection(id: selectedSingleCollection.id, name: name.text!, desc: desc.text, image: img)
                    toast.showToast(message: "Data Updated!")
                }
                else {//insert data
                
                    db.insertSingleCollection(id: selectedSingleId, name: name.text!, desc: desc.text, image: img)
                    toast.showToast(message: "Data Saved!")
                }
            
                //3 second timer for back navigation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
                    //go back to collections
                    guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "singleCollection") as? SingleCollection else {
                        fatalError("Unable to Instantiate Contact View Controller")
                    }
                    vc.selectedCollection = selectedCollection
                    self.navigationController?.pushViewController(vc, animated: true)
                }
        }
    }
}
