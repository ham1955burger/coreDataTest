//
//  BubbleChatViewController.swift
//  bubbleTest
//
//  Created by ouniwang on 10/14/16.
//  Copyright © 2016 ham. All rights reserved.
//

import UIKit

class ChatRoomsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomsTableViewCell") as! ChatRoomsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Bubble", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BubbleChatViewController") as! BubbleChatViewController
        
        let dataSource = FakeDataSource(count: 0, pageSize: 50)
        
        let cell = tableView.cellForRow(at: indexPath) as! ChatRoomsTableViewCell
        vc.title = cell.roomLabel.text
        vc.dataSource = dataSource
        vc.messageSender = dataSource.messageSender
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class ChatRoomsTableViewCell: UITableViewCell {
    @IBOutlet weak var roomLabel: UILabel!
}
