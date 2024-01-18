
import UIKit

protocol ContactListDelegate: AnyObject {
    func reloadContacts()
}

final class ContactListViewController: UIViewController, ContactListDelegate {
    private let model = ContactManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addContactButton(_ sender: UIBarButtonItem) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.delegate = self
        present(detailVC, animated: true)
    }
    
    func reloadContacts() {
        self.tableView.reloadData()
    }
}
    
extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.readContacts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let data = model.readContacts()
        let personIndex = data[indexPath.row]
        
        cell.textLabel?.text = "\(personIndex.name)(\(personIndex.age))"
        cell.detailTextLabel?.text = "\(personIndex.phoneNumber)"
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let list = model.readContacts()
        let data = list[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "delete", 
                                        handler: {[weak self] (action, view, completionHandler) in
            self?.model.deletePerson(inputUuid: data.uuid)
            self?.tableView.reloadData()
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
}
