//
//  ItemDetailsViewController.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import UIKit
import Combine
import LBCTools

class ItemDetailsViewController: UIViewController {
  
  private var viewModel: ItemDetailsViewModel
  private var cancellables : Set<AnyCancellable> = []

  private lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.backgroundColor = .systemBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    view.sameSizeAsSuperView()
    return view
  }()
    
  private lazy var priceLabel: UILabel = {
    let view = UILabel()
    view.textColor = .systemGray
    view.font = UIFont.preferredFont(forTextStyle: .body)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.scrollView.addSubview(view)
    
    view.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 8).isActive = true
    view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
    view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true

    return view
  }()

  private lazy var dateLabel: UILabel = {
    let view = UILabel()
    view.textColor = .systemGray
    view.font = UIFont.preferredFont(forTextStyle: .footnote)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.scrollView.addSubview(view)

    view.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 8).isActive = true
    view.leadingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor).isActive = true

    return view
  }()

  private lazy var itemImageView: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.image = UIImage(systemName: "gift")
    view.translatesAutoresizingMaskIntoConstraints = false
    self.scrollView.addSubview(view)

    view.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 8).isActive = true
    view.leadingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor, constant: 20).isActive = true
    view.trailingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor, constant: -20).isActive = true
    view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

    return view
  }()

  private lazy var descriptionLabel: UILabel = {
    let view = UILabel()
    view.numberOfLines = 0
    view.font = UIFont.preferredFont(forTextStyle: .body)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.scrollView.addSubview(view)

    view.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 8).isActive = true
    view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -8).isActive = true
    view.leadingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor).isActive = true

    return view
  }()

  init(with viewModel: ItemDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    self.setupBinding()
  }
  
  private func setupView() {
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    self.title = self.viewModel.listItem.item.title

    self.priceLabel.text = self.viewModel.listItem.item.price.formatted
    self.dateLabel.text = self.viewModel.listItem.item.creationDate.formatted
    self.viewModel.handle(action: .loadImageData)
    self.descriptionLabel.text = self.viewModel.listItem.item.description
  }
  
  private func setupBinding() {
    self.viewModel.imageData
      .receive(on: DispatchQueue.main)
      .assign(to: \.self.itemImageView.image, on: self)
      .store(in: &self.cancellables)
  }
}
