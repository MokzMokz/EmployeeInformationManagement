//
//  EmployeeListViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeListViewController: UIViewController {

    var viewModel: EmployeeListViewModel?
    private let employeeManager = EmployeeManager.shared
    private var disposeBag = DisposeBag()
    var company = Company()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        // Do any additional setup after loading the view.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
           segue.destination.isKind(of: EditEmployeeViewController.classForCoder()) {
            if let controller = segue.destination as? EditEmployeeViewController {
                controller.employee = employeeManager.employeeList[indexPath.row]
            }
        }
    }
    
    private func setupUI() {
        self.title = company.name
        viewModel?.initialize()
        employeeManager.list.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: EmployeeTableViewCell.reuseIdentifier, cellType: EmployeeTableViewCell.self)) { (_, employee, cell) in

                cell.employee = employee
        }.disposed(by: disposeBag)
        
        
        // Observe item selection events using RxSwift
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                // Handle item selection here
                
                if let employee = self?.employeeManager.employeeList[indexPath.row] {
                    self?.viewModel?.employeeListCoordinatorDelegate?.editEmployee(with: employee)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupData() {
        viewModel?.setUpData(company: company)
    }
   
    @IBAction func pressLogout(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func pressedAdd(_ sender: Any) {
        viewModel?.employeeListCoordinatorDelegate?.addEmployee()
        //self.navigationRouter.presentEditEmployee(company: company)
    }
}
