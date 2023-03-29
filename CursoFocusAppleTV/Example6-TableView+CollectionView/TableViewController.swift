//
//  TableViewController.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // Current focus index for each table cell
    var focusIndex: [Int] = Array.init(repeating: 0, count: 20)
    var currentRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        restoresFocusAfterTransition = false
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: Table Data Source
extension TableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewCell",
            for: indexPath
        ) as! TableViewCell
        cell.setData(
            tableIndex: indexPath.row,
            focusIndex: self.focusIndex[indexPath.row],
            delegate: self
        )
        return cell
    }
}

//MARK: Table Delegate
extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TableViewCell.cellHeight
    }
}

extension TableViewController: TableViewCellDelegate {
    func updateFocusIndex(tableIndex: Int, focusIndex: Int) {
        self.focusIndex[tableIndex] = focusIndex
        self.currentRow = tableIndex
        print("Navigation. currentRow: \(self.currentRow), focusIndex[index]: \(self.focusIndex[tableIndex])")
    }
}

extension TableViewController {
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [tableView]
    }
}
