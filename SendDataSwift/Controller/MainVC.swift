//
//  ViewController.swift
//  SendDataSwift
//
//  Created by Florentin Lupascu on 02/04/2019.
//  Copyright © 2019 Florentin Lupascu. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // Interface Links
    @IBOutlet weak var questionsTableView: UITableView!
    
    // Properties
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainCell
        cell.delegate = self
        cell.configCell()
        //cell.commentLabel.text = How Can I get this Text ?
        //cell.defectImageView.image = How Can I get this Image ?
        return cell
    }
    
    // Set the height of each row from UITableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
}

extension MainVC: MainCellDelegate {
    
    func tappedOnPassOrFail(passBtn: UIButton, failBtn: UIButton) {
        
        if passBtn.isTouchInside {
            print("Click on PASS !")
            
            passBtn.imageView?.image = UIImage(named: "greenTickIcon")
            failBtn.imageView?.image = UIImage(named: "whiteCrossIcon")
        }
        else if failBtn.isTouchInside{
            print("Click on FAIL !")
            
            failBtn.imageView?.image = UIImage(named: "redCrossIcon")
            passBtn.imageView?.image = UIImage(named: "whiteTickIcon")
        }
    }
    
    func tapGestureOnCell() {
        
        showOptionsOnCellTapped()
    }
    
    func receiveImageViewFromCell(imageView: UIImageView) {
        
        print("Image received")
    }
    
    // Show to user a menu with options when press Roadside button
    func showOptionsOnCellTapped(){
        
        let addComment = UIAlertAction(title: "📝 Add Comment", style: .default) { action in
            self.performSegue(withIdentifier: "goToAddComments", sender: nil)
        }
        let addPhoto = UIAlertAction(title: "📷 Add Photo", style: .default) { action in
            // Open Camera
            self.showCamera()
        }

        let actionSheet = configureActionSheet()
        actionSheet.addAction(addComment)
        actionSheet.addAction(addPhoto)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Open camera when the user hold on a cell and choose Camera.
    func showCamera() {
        
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
}

extension MainVC: PopUpDelegate{
    
    func receiveFirstComment(firstComment: String) {
    
        // I need to set the delegate as self here but how ?
        print("Comment received: \(firstComment)")
    }
    
}

extension MainVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    //Dismiss the Camera and display the selected image into the UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }

        
        // How can I access the imageView from my Cell here ?
        //myImageViewFromCell.image = selectedImage
        
        receiveImageViewFromCell(imageView: UIImageView(image: selectedImage)) // This delegate don't work for some reasons. When I debug I can see the image on 'selectedImage' but is not assigned to my UIImageView
    }
    
}

extension UIViewController{
    
    // Configure an UIActionSheet to work for iPhone and iPad. If the user use an iPad then the ActionSheet will be displayed in the middle of the screen.
    func configureActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = []
        }
        
        return actionSheet
    }
}
