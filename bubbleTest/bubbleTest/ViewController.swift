//
//  ViewController.swift
//  bubbleTest
//
//  Created by ouniwang on 10/7/16.
//  Copyright © 2016 ham. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var result: [BubbleTest]?
    
    @IBOutlet weak var emptyLabel: UILabel!
    var sortState: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getTranscriptions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.result?.count != 0 else {
            tableView.isHidden = true
            self.emptyLabel.isHidden = false
            return 0
        }
        
        tableView.isHidden = false
        self.emptyLabel.isHidden = true
        
        return (self.result?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell") as! TestTableViewCell
        
        cell.messageLabel.text = self.result?[indexPath.row].message
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate: String = dateFormatter.string(from: (self.result?[indexPath.row].date)! as Date)
        
        
        cell.dateLabel.text = currentDate
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if !(self.result?[indexPath.row].isReceived)! {
            alert.addAction(UIAlertAction(title: "수정 하기", style: .default, handler: { (action) in
                self.modifyObj(objectIndex: indexPath.row)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "삭제 하기", style: .default, handler: { (action) in
            self.deleteObj(objectIndex: indexPath.row)
            
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Actions

extension ViewController {
    @IBAction func actionReceive(_ sender: AnyObject) {
        // 받기
        self.storeTranscription(date: Date(), isReceived: true, message: "받기 테스트", room: 1, sender: 2)
    }
    
    @IBAction func actionSend(_ sender: AnyObject) {
        // 보내기
        self.storeTranscription(date: Date(), isReceived: false, message: "보내기 테스트", room: 1, sender: 1)
    }
    
    @IBAction func actionSort(_ sender: AnyObject) {
        // 정렬
        self.sortState = !self.sortState
        self.getTranscriptions()
    }
    
    @IBAction func actionSearch(_ sender: AnyObject) {
        // 검색
    }
    
    @IBAction func deleteAllObject(_ sender: AnyObject) {
        // 전체 삭제
        appDelegate.deleteAllData(entity: "BubbleTest") { (error) in
            if error == nil {
                self.getTranscriptions()
            } else {
                print("\(error)")
            }
        }
        
    }
    
}


// MARK: - Functions

extension ViewController {
    func storeTranscription(date: Date, isReceived: Bool, message: String, room: Int, sender: Int) {
        let context = appDelegate.getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "BubbleTest", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(date, forKey: "date")
        transc.setValue(isReceived, forKey: "isReceived")
        transc.setValue(message, forKey: "message")
        transc.setValue(room, forKey: "room")
        transc.setValue(sender, forKey: "sender")
        
        //save the object
        appDelegate.saveContext { (error) in
            if error == nil {
                self.getTranscriptions()
            } else {
                print(error)
            }
        }
    }
    
    
    
    //TODO: appDelegate로 이동시키기
    
    func getTranscriptions() {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<BubbleTest> = BubbleTest.fetchRequest()
        
        // sort : order by
        if self.sortState {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        }
        
        // sort : limit & offset
//        fetchRequest.fetchLimit = 10
//        fetchRequest.fetchOffset = 0
        
//        fetchRequest.propertiesToGroupBy = [NSArray().objects(at: "isReceived")]
        
        do {
            //go get the results
            self.result = try appDelegate.getContext().fetch(fetchRequest)
            self.tableView.reloadData()
            
            /*
             //I like to check the size of the returned results!
             print ("num of results = \(searchResults.count)")
             
             //You need to convert to NSManagedObject to use 'for' loops
             for trans in searchResults as [NSManagedObject] {
             //get the Key Value pairs (although there may be a better way to do that...
             print("\(trans.value(forKey: "message"))")
             }
             */
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func deleteObj(objectIndex: Int) {
        let context = appDelegate.getContext()
        
        context.delete(self.result![objectIndex])
        appDelegate.saveContext { (error) in
            if error == nil {
                self.getTranscriptions()
            } else {
                print(error)
            }
        }
        self.getTranscriptions()
    }
    
    func modifyObj(objectIndex: Int) {
        let obj = self.result?[objectIndex]
        
        obj?.setValue("보내기 수정 테스트", forKey: "message")
        
        appDelegate.saveContext { (error) in
            if error == nil {
                self.getTranscriptions()
            } else {
                print(error)
            }
        }
        self.getTranscriptions()
    }
}

