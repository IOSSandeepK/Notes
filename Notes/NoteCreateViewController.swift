//
//  NoteCreateViewController.swift
//  Notes
//
//  Created by apple on 02/09/19.
//  Copyright © 2019 Swiftter. All rights reserved.
//

import UIKit

class NoteCreateViewController: UIViewController ,UITextViewDelegate {
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingNote : Note?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    var imagePicker: ImagePicker!
    var image: UIImage!
    
    
    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( noteTextTextView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if self.changingNote != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    
    func setChangingNote(changingNote : Note) {
        self.changingNote = changingNote
    }
    
    private func addItem() -> Void {
        let note = Note(
            noteTitle:     noteTitleTextField.text!,
            noteText:      noteTextTextView.text,
            noteTimeStamp: noteCreationTimeStamp)
        
        NoteStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }
    
    private func changeItem() -> Void {
        // get changed note instance
        if let changingNote = self.changingNote {
            // change the note through note storage
            NoteStorage.storage.changeNote(
                noteToBeChanged: Note(
                    noteId:        changingNote.noteId,
                    noteTitle:     noteTitleTextField.text!,
                    noteText:      noteTextTextView.text,
                    noteTimeStamp: noteCreationTimeStamp)
            )
            // navigate back to list of notes
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                            withIdentifier: "backToMasterView",
                                            sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        // check if we are in create mode or in change mode
        if let changingNote = self.changingNote {
            // in change mode: initialize for fields with data coming from note to be changed
            noteDateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            noteTextTextView.text = changingNote.noteText
            noteTitleTextField.text = changingNote.noteTitle
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // in create mode: set initial time stamp label
            noteDateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp)) //NEw
        }
        
        // initialize text view UI - border width, radius and color
        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextTextView.layer.borderWidth = 1.0
        noteTextTextView.layer.cornerRadius = 5
        
        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//        image = self.imagePicker.loadImageFromDocumentDirectory(nameOfImage: "image001.png")
//        self.imageView.image = image


    }
    /// MARK:
    /// This method is responsible editProjectImage from button action
    ///
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
        
    }
    
    
    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changingNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( noteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
}


/// MARK:
/// This method is responsible ImagePicker delegate method
///
extension NoteCreateViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = image
            self.imagePicker.saveImageToDocumentDirectory(image: image!)
        }
        
    }
}

