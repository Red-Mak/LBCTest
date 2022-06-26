//
//  ItemsListViewController.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import UIKit
import Combine
import LBCNetwork

class ItemsListViewController: UIViewController {
  
  private enum Section {
    case main
    case recentlyAdded
  }
  
  private var cancellables : Set<AnyCancellable> = []
  private let viewModel: ItemsListViewModel
  private var dataSource: UITableViewDiffableDataSource<Section, ListItem>! = nil

  private lazy var tableView: UITableView = {
    let view = UITableView(frame: .zero, style: .plain)
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(ItemCellView.self, forCellReuseIdentifier: "cell")
    self.view.addSubview(view)
    view.sameSizeAsSuperView()
    view.estimatedRowHeight = 60
    return view
  }()
  
  private lazy var filtertemsBarButton: UIBarButtonItem = {
    let filterButton = UIBarButtonItem(title: "",
                                     image: UIImage(systemName: "list.dash"),
                                     primaryAction: nil,
                                     menu: self.menuForSortButton())
    filterButton.isEnabled = false
    return filterButton
  }()
  
  init(with viewModel: ItemsListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupBiding()
    self.viewModel.handle(action: .fetchItems)
    self.navigationItem.rightBarButtonItem = self.filtertemsBarButton
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    self.title = "Votre liste shopping"
  }
  
  private func setupBiding() {
    self.viewModel.currentListItems
      .receive(on: DispatchQueue.main)
      .sink { error in
        print(error)
      } receiveValue: { items in
        self.applyData(listItems: items)
        self.updateMenu()
      }
      .store(in: &self.cancellables)
  }
  
  private func applyData(listItems: [ListItem]) {
    self.dataSource = UITableViewDiffableDataSource<Section, ListItem>(tableView: tableView, cellProvider: { (tableV : UITableView, indexPath: IndexPath, item: ListItem) -> ItemCellView in
      guard let cell = tableV.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemCellView else {
        fatalError("can't create cell")
      }
      cell.configure(with: item)
      return cell
    })
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
      snapshot.appendSections([.main])
    snapshot.appendItems(listItems, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func menuForSortButton() -> UIMenu {
        
    var actions = [UIAction]()
    
    for filterType in self.viewModel.filters {
      let image = self.viewModel.currentFilter == filterType ? UIImage(systemName: "checkmark") : nil
      let action = UIAction(title: filterType.title,
                            image: image) { (action) in
        self.viewModel.handle(action: .filter(type: filterType))
      }
      actions.append(action)
    }

    let menu = UIMenu(title: "Filtre par catégorie",
                      children: actions)
    return menu
  }
  
  private func updateMenu() {
    self.filtertemsBarButton.menu = menuForSortButton()
    self.filtertemsBarButton.isEnabled = true
  }
}

extension ItemsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let listItem = self.viewModel.currentListItems.value[indexPath.row]
    
    let viewModel = ItemDetailsViewModel(with: listItem, networkProvider: NetworkManager.auto)
    let detailViewController = ItemDetailsViewController(with: viewModel)
    let navController = UINavigationController(rootViewController: detailViewController)
    
    self.navigationController?.present(navController, animated: true)
  }
}

