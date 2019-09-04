//
//  DetailViewController.swift
//  Notes
//
//  Created by apple on 02/09/19.
//  Copyright © 2019 Swiftter. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDate: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
                let dateLabel = noteDate,
                let textView = noteTextTextView {
                topicLabel.text = detail.noteTitle
                dateLabel.text = NoteDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeNoteSegue" {
            let noteViewController = segue.destination as! NoteCreateViewController
            if let detail = detailItem {
                noteViewController.setChangingNote(
                    changingNote: detail)
            }
        }
    }
}

