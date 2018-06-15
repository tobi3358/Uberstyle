//
//  PendingOrderTableViewController.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 13/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PendingOrderTableViewController: UITableViewController{
    
    //var tableData = Array<JSONTableData>()
    var tableData: NSArray = NSArray()
    var UID:Int = 0
    var origin:String = ""
    var element:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://localhost/api/orders/pending")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                //create json object from data
                if var json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                    // handle json...
                    //print(json)
                    var jsonElement = NSDictionary()
                    let Data = NSMutableArray()
                    for i in 0 ..< json.count
                    {
                        jsonElement = json[i] as! NSDictionary
                        print(json[i])
                        let cell = Cell()
                        cell.object = jsonElement
                        print(cell)
                        Data.add(cell)
                        
                    }
                    
                    DispatchQueue.main.sync(execute: { () -> Void in
                        
                        self.itemsDownloaded(items: Data)
                        
                    })
                } else {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    func itemsDownloaded(items: NSArray) {
        
        tableData = items
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    var tableObject:JSONTableData?
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        /*tableObject = tableData[indexPath.row]
        cell.textLabel?.text = "\(tableObject?.tempString["order_id"])"*/
        let item: Cell = tableData[indexPath.row] as! Cell
        cell.textLabel?.text = "\(item.ID!)"
        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PendingOrderTableviewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PendingOrderTableviewCell!
        
        if cell == nil {
            cell = PendingOrderTableviewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        let item: Cell = tableData[indexPath.row] as! Cell
        cell?.order_idtxt.text = "\(item.object!["order_id"]!)"
        cell?.Price.text = "\(item.object!["price"]!)"
        cell?.Adressetxt.text = item.object!["origin"]! as! String
        print(item)
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableData[indexPath.item])
        let IDitem: Cell = tableData[indexPath.row] as! Cell
        var elementitem = IDitem.object
        element = elementitem!
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Info", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("pre for seque")

        if (segue.identifier == "Info") {
            let vc = segue.destination as! DriverViewController
            vc.jsonlement = element
        }else{
            print("hvor er planen")
        }
    }
}

