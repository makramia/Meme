//
//  sentMemeTableViewController.swift
//  MemeMe
//
//  Created by makramia on 20/11/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class sentMemeTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme(_:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    @objc func addMeme(_ sender: UIBarButtonItem) {
       
        if let navigationController = navigationController {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "memeEditor") as! MemeEditorViewController
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    @objc func editMeme(_ sender: UIBarButtonItem){
        if(!tableView.isEditing){
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        }else{
            tableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
}

extension sentMemeTableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "memeTableCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText! + " ... " + meme.bottomText!
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = .scaleToFill
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt  indexPath: IndexPath){
        
        let meme = memes[(indexPath as NSIndexPath).row]
        if let navigationController = navigationController {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailView") as! MemeDetailViewController
            vc.memedImage = meme.memedImage
            navigationController.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (self.tableView.isEditing) {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }
}
