//
//  MovieDetailsViewController.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
   
   // MARK: Properties
   private let viewModel: MovieDetailsViewModelProtocol
   private let coordinator: MoviesCoordinatorProtocol
   
   // MARK: Initialization
   init(
       viewModel: MovieDetailsViewModelProtocol,
       coordinator: MoviesCoordinatorProtocol
   ) {
       self.viewModel = viewModel
       self.coordinator = coordinator
       super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
       assertionFailure("init(coder:) has not been implemented. This class does not support initialization from Interface Builder")
       return nil
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .green
   }
}
