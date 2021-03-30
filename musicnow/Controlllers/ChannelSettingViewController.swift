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
    var feautures: [String] = ["Top Chart", "Recent"]
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return feautures.count
        }
        
        return channels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChannelSettingTableViewCell
        if indexPath.section == 0 {
            cell.titleLabel.text = feautures[indexPath.row]
        }else{
            cell.titleLabel.text = channels[indexPath.row].title
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Channels"
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        channels.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}
