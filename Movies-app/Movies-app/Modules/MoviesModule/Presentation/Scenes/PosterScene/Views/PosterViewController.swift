//
//  PosterViewController.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

final class PosterViewController: UIViewController {

   private let viewModel: PosterViewModelProtocol

   init(
       viewModel: PosterViewModelProtocol
   ) {
       self.viewModel = viewModel
       super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
       assertionFailure("init(coder:) has not been implemented. This class does not support initialization from Interface Builder")
       return nil
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .yellow
   }
}