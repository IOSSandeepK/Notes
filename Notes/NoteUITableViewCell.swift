//
//  NoteUITableViewCell.swift
//  Notes
//
//  Created by apple on 02/09/19.
//  Copyright © 2019 Swiftter. All rights reserved.
//

import UIKit

class NoteUITableViewCell: UITableViewCell {
    private(set) var noteTitle : String = ""
    private(set) var noteText  : String = ""
    private(set) var noteDate  : String = ""
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
}
