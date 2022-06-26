//
//  ItemCell.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 23/06/2022.
//

import Foundation
import UIKit
import Combine
import LBCNetwork

class ItemCellView: UITableViewCell {
  private var viewModel = ItemCellViewModel(with: NetworkManager.auto)
  private var listItem: ListItem?
  private var cancellables : Set<AnyCancellable> = []

  lazy var itemImageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.layer.cornerRadius = 10
    view.clipsToBounds = true
    view.image = UIImage(systemName: "tv")
    view.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(view)
    view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
    view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
    view.heightAnchor.constraint(equalToConstant: 80).isActive = true
    view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    return view
  }()
  
  lazy var urgentLabel: UILabel = {
    let view = UILabel()
    view.backgroundColor = .orange
    view.textColor = .label
    view.layer.cornerRadius = 8
    view.clipsToBounds = true
    view.textAlignment = .center
    view.font = UIFont.preferredFont(forTextStyle: .footnote)
    self.itemImageView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.leadingAnchor.constraint(equalTo: self.itemImageView.leadingAnchor, constant: 2).isActive = true
    view.trailingAnchor.constraint(equalTo: self.itemImageView.trailingAnchor, constant: -2).isActive = true
    view.bottomAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: -2).isActive = true
    return view
  }()

  lazy var labelsStackView: UIStackView = {
    let view = UIStackView()
    self.contentView.addSubview(view)
    view.axis = .vertical
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: self.itemImageView.topAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: self.itemImageView.trailingAnchor, constant: 8).isActive = true
    view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
    return view
  }()

  lazy var categoryLabel: UILabel = {
    let view = UILabel()
    view.font = UIFont.preferredFont(forTextStyle: .footnote)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.labelsStackView.addArrangedSubview(view)
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.numberOfLines = 0
    view.font = UIFont.preferredFont(forTextStyle: .title2)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.labelsStackView.addArrangedSubview(view)
    return view
  }()

  lazy var priceLabel: UILabel = {
    let view = UILabel()
    view.font = UIFont.preferredFont(forTextStyle: .footnote)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.labelsStackView.addArrangedSubview(view)
    return view
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with listItem: ListItem) {
    self.listItem = listItem
    self.titleLabel.text = self.listItem?.item.title
    self.categoryLabel.text = self.listItem?.category.name
    self.priceLabel.text = self.listItem?.item.price.formatted
    self.urgentLabel.text = self.listItem?.item.isUrgent == true ? "Urgent" : nil
    self.viewModel.handle(action: .loadImageData(images: listItem.item.imagesUrl))
  }
  
  override func prepareForReuse() {
    guard let listItem = listItem else { return }
    
    self.viewModel.handle(action: .cancelCurrentImageLoading(url: listItem.item.imagesUrl.small ?? listItem.item.imagesUrl.thumb ?? "NA"))
  }
  
//MARK: - private
  private func setupBinding() {
    self.viewModel.imageData
      .receive(on: DispatchQueue.main)
      .assign(to: \.self.itemImageView.image, on: self)
      .store(in: &self.cancellables)
  }
}
