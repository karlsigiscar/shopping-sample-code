//
//  CartModelTests.swift
//  ECommerceSampleAppTests
//
//  Created by Writer on 16/01/2026.
//

import Testing
@testable import ECommerceSampleApp  // ← change to your actual module name

@Suite("CartModel Tests")
@MainActor
struct CartModelTests {
    
    // MARK: - Helpers
    
    private func makeSUT() -> CartModel {
        CartModel()
    }
    
    private func sampleProduct(id: String = "751b7271-5755-4bb9-8e2b-f038bcd8d540",
                               sku: String = "4894894",
                               name: String = "T-Shirt",
                               description: String = "Amazing Mando T-shirt with Grogu",
                               image: String = "https://placehold.co/600x400/EEE/31343C",
                               price: Double = 29.99) -> ProductModel {
        ProductModel(id: id, sku: sku, name: name, description: description, image: image, price: price) // adjust init to match your real ProductModel
    }
    
    // MARK: - Adding products
    
    @Test("Adding a new product should create item with quantity 1")
    func GivenAnEmptyCart_WhenAddingANewProduct_ThenTheQuantityShouldBeOne() {
        let sut = makeSUT()
        let product = sampleProduct(id: "abc-001")
        
        sut.addProduct(product)
        
        #expect(sut.items.count == 1)
        #expect(sut.items.first?.product.id == "abc-001")
        #expect(sut.items.first?.quantity == 1)
    }
    
    @Test("Adding the same product twice should increase quantity")
    func GivenAnEmptyCart_WhenAddingTheSameProductTwice_ThenTheQuantityShouldBeTwo() {
        let sut = makeSUT()
        let product = sampleProduct(id: " repeated ")
        
        sut.addProduct(product)
        sut.addProduct(product)
        
        #expect(sut.items.count == 1)
        #expect(sut.items.first?.quantity == 2)
    }
    
    // MARK: - Removing products
    
    @Test("removeProduct should remove item completely")
    func GivenTheCartContainsAProduct_WhenRemovingThatProduct_ThenTheCartShouldBeEmpty() {
        let sut = makeSUT()
        let product = sampleProduct(id: "rm-777")
        
        sut.addProduct(product)
        #expect(sut.contains(product) == true)
        
        sut.removeProduct(product)
        
        #expect(sut.items.isEmpty == true)
        #expect(sut.contains(product) == false)
    }
    
    @Test("removeProduct when item doesn't exist should do nothing")
    func GivenANonExistentProduct_WhenRemovingThatProduct_ThenTheCartShoulHaveTheSameCount() {
        let sut = makeSUT()
        let product = sampleProduct(id: "ghost")
        
        let initialCount = sut.items.count
        sut.removeProduct(product)
        
        #expect(sut.items.count == initialCount)
    }
    
    // MARK: - Quantity modifications
    
    @Test("increaseQuantity should increment by 1")
    func GivenACartWithAProduct_WhenInvokingIncreaseQuantity_ThenTheQuantityShouldBeUpdatedAccordingly() throws {
        let sut = makeSUT()
        let product = sampleProduct(id: "inc-1")
        sut.addProduct(product)
        
        let item = try #require(sut.items.first)
        
        sut.increaseQuantity(item)
        #expect(item.quantity == 2)
        
        sut.increaseQuantity(item)
        #expect(item.quantity == 3)
    }
    
    @Test("decreaseQuantity should decrement by 1")
    func GivenACartWithAProduct_WhenInvokingDecreaseQuantity_ThenTheQuantityShouldBeUpdatedAccordingly() throws {
        let sut = makeSUT()
        let product = sampleProduct(id: "dec-9")
        sut.addProduct(product)
        sut.addProduct(product)           // qty = 2
        
        let item = try #require(sut.items.first)
        
        sut.decreaseQuantity(item)
        #expect(item.quantity == 1)
        
        sut.decreaseQuantity(item)
        #expect(item.quantity == 0)
    }
    
    @Test("decreaseQuantity below 1 should stay at 0 (current behavior)")
    func GivenACartWithAProductAndACountOfOne_WhenInvokingDecreaseQuantityTwice_ThenTheQuantityShouldBeZero() throws {
        let sut = makeSUT()
        let product = sampleProduct()
        sut.addProduct(product)
        
        let item = try #require(sut.items.first)
        
        sut.decreaseQuantity(item)  // → 0
        sut.decreaseQuantity(item)  // should stay 0
        
        #expect(item.quantity == 0)
    }
}
