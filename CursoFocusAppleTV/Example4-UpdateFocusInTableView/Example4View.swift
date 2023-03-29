//
//  Example4View.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 19/3/23.
//

import UIKit

class Example4View: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateFocusButton: UIButton!

    var tableFocusView: Int = 0

    let options = [
        "Table option 0",
        "Table option 1",
        "Table option 2",
        "Table option 3",
        "Table option 4",
        "Table option 5",
        "Table option 6",
        "Table option 7",
        "Table option 8",
        "Table option 9",
        "Table option 10",
        "Table option 11",
        "Table option 12",
        "Table option 13",
        "Table option 14",
        "Table option 15",
        "Table option 16",
        "Table option 17"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        _ = self.addFocusGuide(from: updateFocusButton, to: tableView, direction: .right)

        let focusGuide = UIFocusGuide()
        self.view.addLayoutGuide(focusGuide)
        focusGuide.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.top)
            make.bottom.equalTo(self.tableView.snp.bottom)
            make.right.equalTo(self.tableView.snp.left)
            make.width.equalTo(20)
            make.height.equalTo(self.tableView.snp.height)
        }
        focusGuide.preferredFocusEnvironments = [updateFocusButton]
        focusGuide.isEnabled = true

        // TODO: remembersLastFocusedIndexPath
    }

    @IBAction func updateFocusAction(_ sender: Any) {
        if let index = Int(textField.text ?? ""), index >= 0, index < options.count {
            self.tableFocusView = index
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [self.updateFocusButton]
    }
}

extension Example4View: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = options[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

extension Example4View: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    // TODO: indexPathForPreferredFocusedView
}
