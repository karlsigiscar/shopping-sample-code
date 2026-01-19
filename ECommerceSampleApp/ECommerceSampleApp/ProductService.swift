//
//  ProductService.swift
//  ECommerceSampleApp
//
//  Created by Writer on 15/01/2026.
//
import Foundation
import Combine

class ProductService: NSObject, ObservableObject {
        
    // MARK: - Cache
    
    private struct CachedData<T> {
        let data: T
        let timestamp: Date
        let ttl: TimeInterval
        
        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > ttl
        }
    }
    
    // MARK: - Properties
    
    private let baseURLString = "https://raw.githubusercontent.com/karlsigiscar/shopping-sample-code/refs/heads/main/ECommerceSampleApp"
    
    @Published var products: [ProductModel]?
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    
    private var cancellables: Set<AnyCancellable> = []
    private var userCache: CachedData<User>?
    private var productsCache: CachedData<[ProductModel]>?
    
    // Subject for debouncing search queries
    private let searchSubject = PassthroughSubject<String, Never>()
    
    // Current network requests for cancellation
    private var currentLoadTask: AnyCancellable?
    
    // MARK: - Configuration
    
    private let cacheTTL: TimeInterval = 300 // 5 minutes
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupSearchDebouncing()
    }
    
    private func setupSearchDebouncing() {
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                self?.performSearch(searchTerm)
            }
            .store(in: &cancellables)
    }
    
    func search(term: String) {
        searchSubject.send(term)
    }
    
    private func performSearch(_ term: String) {
        guard let allProducts = products else { return }
        
        if term.isEmpty {
            // Reset to all products
            return
        }
        
        let filtered = allProducts.filter { product in
            product.name.localizedCaseInsensitiveContains(term) ||
            product.description.localizedCaseInsensitiveContains(term)
        }
        
        self.products = filtered
    }
    
    public func loadUserAndPromotions() {
        // Cancel any existing request
        currentLoadTask?.cancel()
        
        isLoading = true
        error = nil
        
        currentLoadTask = createUserAndPromotionsPublisher()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("Failed to load: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] products in
                    self?.products = products
                    print("Successfully loaded \(products.count) products")
                }
            )
        
        currentLoadTask?.store(in: &cancellables)
    }
    
    private func createUserAndPromotionsPublisher() -> AnyPublisher<[ProductModel], AppError> {
        // First, get user (with caching)
        getUserPublisher()
            .flatMap { [weak self] user -> AnyPublisher<[ProductModel], AppError> in
                guard let self = self else {
                    return Fail(error: AppError.configuration).eraseToAnyPublisher()
                }
                
                // Then get products for that user
                return self.loadProductsOnPromotionForUser(userID: user.id)
                    .map { products in
                        // Filter based on membership
                        products.filter { !$0.membersOnly || user.isClubMember }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getUserPublisher() -> AnyPublisher<User, AppError> {
        // Check cache first
        if let cached = userCache, !cached.isExpired {
            return Just(cached.data)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        }
        
        // Cache miss - fetch from network
        guard let url = URL(string: "\(baseURLString)/login.json") else {
            return Fail(error: AppError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { AppError.networkFailure($0) }
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { AppError.decodingFailure($0) }
            .retry(maxRetries)
            .handleEvents(receiveOutput: { [weak self] user in
                // Cache the user
                self?.userCache = CachedData(data: user, timestamp: Date(), ttl: self?.cacheTTL ?? 300)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func loadProductsOnPromotionForUser(userID: Int) -> AnyPublisher<[ProductModel], AppError> {
        // Check cache
        if let cached = productsCache, !cached.isExpired {
            return Just(cached.data)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: "\(baseURLString)/products.json?userID=\(userID)") else {
            return Fail(error: AppError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { AppError.networkFailure($0) }
            .map(\.data)
            .decode(type: [ProductModel].self, decoder: JSONDecoder())
            .mapError { AppError.decodingFailure($0) }
            .retryWithBackoff(maxRetries: maxRetries, delay: retryDelay)
            .mapError { error in
                // Convert any Error to AppError
                if let appError = error as? AppError {
                    return appError
                } else {
                    return AppError.networkFailure(error)
                }
            }
            .handleEvents(receiveOutput: { [weak self] products in
                // Cache the products
                self?.productsCache = CachedData(data: products, timestamp: Date(), ttl: self?.cacheTTL ?? 300)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func loadMultipleCategories(userID: Int, categories: [String]) -> AnyPublisher<[[ProductModel]], AppError> {
        let publishers = categories.map { category in
            loadProductsByCategory(userID: userID, category: category)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func loadProductsByCategory(userID: Int, category: String) -> AnyPublisher<[ProductModel], AppError> {
        loadProductsOnPromotionForUser(userID: userID)
            .map { products in
                products.filter { $0.category == category }
            }
            .eraseToAnyPublisher()
    }
    
    func createSharedProductsPublisher(userID: Int) -> AnyPublisher<[ProductModel], AppError> {
        loadProductsOnPromotionForUser(userID: userID)
            .share() // Prevents multiple network calls for multiple subscribers
            .eraseToAnyPublisher()
    }
    
    func clearCache() {
        userCache = nil
        productsCache = nil
    }
    
    func invalidateUserCache() {
        userCache = nil
    }
    
    func invalidateProductsCache() {
        productsCache = nil
    }
    
    // MARK: - Cancellation
    
    func cancelCurrentLoad() {
        currentLoadTask?.cancel()
        isLoading = false
    }
}

// MARK: - Publisher Extensions

extension Publisher {
    func retryWithBackoff(maxRetries: Int, delay: TimeInterval) -> AnyPublisher<Output, Error> {
        self.catch { error -> AnyPublisher<Output, Error> in
            guard maxRetries > 0 else {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return Just(())
                .delay(for: .seconds(delay), scheduler: DispatchQueue.global())
                .flatMap { _ -> AnyPublisher<Output, Error> in
                    self.retryWithBackoff(
                        maxRetries: maxRetries - 1,
                        delay: delay * 2.0
                    )
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
