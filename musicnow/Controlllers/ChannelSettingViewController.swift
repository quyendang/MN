//
//  ChannelSettingViewController.swift
//  musicnow
//
//  Created by QuyenDang on 20/02/2021.
//

import UIKit

class ChannelSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var channels: [FeautureChannel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        channels = Bundle.main.decode(FeautureChannelList.self, from: "data.json").items
    }

    @IBAction func esit(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
}


extension ChannelSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChannelSettingTableViewCell
        cell.titleLabel.text = channels[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        channels.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
