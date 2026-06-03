//
//  MainViewController.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var viewModel: MainViewModel
    private var didScrollToInitialPosition = false
    private var pendingReloadWorkItem: DispatchWorkItem?
    private(set) var isAdjustingCarouselPosition = false
    
    // MARK: - UI
    
    private lazy var carouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CarouselCompositionalLayout.make(delegate: self)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CarouselImageCell.self,
            forCellWithReuseIdentifier: CarouselImageCell.reuseIdentifier
        )
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfPages = viewModel.pages.count
        control.currentPage = viewModel.selectedPageIndex
        control.currentPageIndicatorTintColor = .systemBlue
        control.pageIndicatorTintColor = .systemGray2
        return control
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    private lazy var emptySearchStateView: UIView = {
        let containerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("main.search.empty", comment: "Empty state when search returns no items")
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = .zero
        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
        return containerView
    }()
    
    private lazy var statisticsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = Layout.floatingButtonSize / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.18
        button.layer.shadowRadius = Layout.shadowRadius
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.imageView?.contentMode = .center
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Layout.symbolSize, weight: .bold)
        let image = UIImage(systemName: "ellipsis", withConfiguration: symbolConfiguration)?
            .rotated(by: .pi / 2)
        
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapStatisticsButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.addGestureRecognizer(hideKeyboardTapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        guard !didScrollToInitialPosition else { return }
        didScrollToInitialPosition = true
        scrollToInitialPosition()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(statisticsButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statisticsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.horizontalInset),
            statisticsButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Layout.floatingButtonBottomInset),
            statisticsButton.widthAnchor.constraint(equalToConstant: Layout.floatingButtonSize),
            statisticsButton.heightAnchor.constraint(equalToConstant: Layout.floatingButtonSize)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        tableView.contentInset.bottom = Layout.listBottomInset
        tableView.verticalScrollIndicatorInsets.bottom = Layout.listBottomInset
        tableView.sectionHeaderTopPadding = .zero
        tableView.backgroundView = emptySearchStateView
        emptySearchStateView.isHidden = true
        
        setupTableHeader()
        
        tableView.register(
            SearchBarHeaderView.self,
            forHeaderFooterViewReuseIdentifier:
                SearchBarHeaderView.reuseIdentifier
        )
    }
    
    private func setupTableHeader() {
        let header = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.bounds.width,
                height: Layout.carouselHeight + 60
            )
        )

        header.backgroundColor = .systemBackground

        header.addSubview(carouselCollectionView)
        header.addSubview(pageControl)

        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: header.topAnchor, constant: Layout.spaceXL),
            carouselCollectionView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: Layout.carouselHeight),

            pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: Layout.spaceS),
            pageControl.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -Layout.spaceS),
        ])

        tableView.tableHeaderView = header
    }
    
    @objc private func didTapStatisticsButton() {
        viewModel.navigateToStatisticSheet()
    }
    
    // MARK: - Carousel
    
    private func scrollToInitialPosition() {
        guard !viewModel.pages.isEmpty else { return }
        let middleIndex = CarouselLoop.middleIndex(pageCount: viewModel.pages.count)
        DispatchQueue.main.async {
            self.carouselCollectionView.scrollToItem(
                at: IndexPath(item: middleIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    private func recenterIfNeeded(at virtualIndex: Int) {
        guard !isAdjustingCarouselPosition else { return }
        
        let pageCount = viewModel.pages.count
        guard pageCount > 0 else { return }
        
        let threshold = pageCount * 10
        let totalItems = CarouselLoop.virtualItemCount(pageCount: pageCount)
        guard virtualIndex < threshold || virtualIndex > totalItems - threshold else { return }
        
        let centeredIndex = CarouselLoop.middleIndex(pageCount: pageCount) + (virtualIndex % pageCount)
        isAdjustingCarouselPosition = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.carouselCollectionView.scrollToItem(
                at: IndexPath(item: centeredIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            self.isAdjustingCarouselPosition = false
        }
    }
    
    // MARK: - Table reload
    
    private func reloadTableDebounced() {
        pendingReloadWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
            self.updateEmptySearchState()
        }
        pendingReloadWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
    }
    
    private func updateEmptySearchState() {
        emptySearchStateView.isHidden = !viewModel.filteredItems.isEmpty
    }
    // MARK: - Gesture
    private lazy var hideKeyboardTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        return gesture
    }()
    
    @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CarouselLoop.virtualItemCount(pageCount: viewModel.pages.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselImageCell.reuseIdentifier,
            for: indexPath
        ) as? CarouselImageCell else {
            return UICollectionViewCell()
        }
        let realIndex = CarouselLoop.realIndex(for: indexPath.item, pageCount: viewModel.pages.count)
        cell.configure(imageName: viewModel.pages[realIndex].imageName)
        return cell
    }
}

// MARK: - CarouselLayoutDelegate

extension MainViewController: CarouselLayoutDelegate {
    
    var pageCount: Int { viewModel.pages.count }
    
    func carouselDidScroll(toVirtualIndex index: Int) {
        let realIndex = CarouselLoop.realIndex(for: index, pageCount: viewModel.pages.count)
        pageControl.currentPage = realIndex
        let pageChanged = viewModel.selectPage(at: realIndex)
        if pageChanged { reloadTableDebounced() }
        recenterIfNeeded(at: index)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(item: viewModel.filteredItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Layout.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Layout.searchBarHeight + Layout.spaceS * 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SearchBarHeaderView.reuseIdentifier
        ) as? SearchBarHeaderView
        else {
            return nil
        }
        
        header.searchBar.delegate = self
        
        header.searchBar.text = viewModel.searchText
        
        return header
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
        UIView.performWithoutAnimation {
            tableView.reloadData()
        }
        updateEmptySearchState()
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
}
