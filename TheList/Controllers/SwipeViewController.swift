//
//  SwipeViewController.swift
//  TheList
//
//  Created by Sergey on 22.01.2022.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UIViewController, SwipeTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate {
   
    @objc dynamic func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    @objc dynamic func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
             cell.delegate = self

         return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
            self.destroy(at: indexPath.row)
        }
        deleteAction.image = UIImage(systemName: "trash")
            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    @objc dynamic func destroy (at indexPath: Int) {
    }
    
    
}
