//
//  TableViewController.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/14/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

class MemeTableVC: UITableViewController {

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddMeme))
        self.tableView.rowHeight = 100
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memesArray
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.memedImage = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        cell.textLabel?.text = self.memes[indexPath.row].topText
        cell.detailTextLabel?.text = self.memes[indexPath.row].bottomText
        cell.imageView?.image = self.memes[indexPath.row].image
        return cell
    }

     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.memes = appDelegate.memesArray
            appDelegate.memesArray.remove(at: indexPath.row)
            self.memes.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red

        return [delete]
    }
    
    //Opens MemeEditor for creating memes.
    func AddMeme(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddMemeVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        self.navigationController?.present(AddMemeVC, animated: true, completion: nil)
    }
}
