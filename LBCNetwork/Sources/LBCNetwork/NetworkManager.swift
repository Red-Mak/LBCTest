//
//  NetworkManager.swift
//  TestLeBonCoin
//
//  Created by Radhouani Malek on 22/06/2022.
//

import Foundation
import Combine

public class NetworkManager: NetworkProvider {

  private let categoriesURL: String
  private let itemsURL: String
  private let domaineError = "com.lbc.error"
  
  /// used to store current requestTasks to be able to cancel them
  fileprivate var requests: [String:URLSessionDataTask] = [:]
  
  /// user the default URLSession configuration
  private lazy var defaultURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration)
  }()
  
  /// URLSession that return cached data if found, otherwise it will load remote data
  private lazy var cacheURLSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
    return URLSession(configuration: configuration)
  }()
  
  /// decoder that uses snake case convertion and `yyyy-MM-dd'T'HH:mm:ssZ`date format to decode dates
  private lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  public init(with categoriesURL: String, itemsURL: String) {
    self.categoriesURL = categoriesURL
    self.itemsURL = itemsURL
  }

  //MARK: - Public
    
  /// will load Items from remote
  /// - Parameter url: remote url
  /// - Returns: a publisher with the result: [Item] or error
  /// - Note: the request will not use caches
  public func items() -> AnyPublisher<[Item], Error> {
    guard let url = URL(string: self.itemsURL) else {
      return Fail(error: NSError(domain: self.domaineError,
                                 code: -100, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
      .eraseToAnyPublisher()
    }
    return self.request(with: url)
  }
  
  /// will load categories from remote
  /// - Returns: a publisher with the result: [ItemCategory] or error
  /// - Note: the request will not use caches
  public func categories() -> AnyPublisher<[ItemCategory], Error> {
    guard let url = URL(string: self.categoriesURL) else {
      return Fail(error: NSError(domain: self.domaineError,
                                 code: -100, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"]))
      .eraseToAnyPublisher()
    }
    return self.request(with: url)
  }
  
  /// will load image data from remote
  /// - Returns: a publisher with the result: Data or error
  /// - Note: the request will use caches if available
  public func image(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let dataTask = self.cacheURLSession.dataTask(with: url) { (data, response, error) in
      if let anError = error {
        completion(.failure(anError))
      }else{
        if let data = data {
          completion(.success(data))
        }else{
          completion(.failure(NSError(domain: self.domaineError, code: 404)))
        }
      }
    }
    
    self.requests[url.absoluteString] = dataTask
    dataTask.resume()
  }
  
  
  /// will cancel the request if running
  /// - Parameter requestIdentifier: request identifier, usually its the request url
  public func cancelRequest(with requestIdentifier: String) {
    if let request = self.requests.first(where: {$0.key == requestIdentifier}){
      request.value.cancel()
      self.requests.removeValue(forKey: requestIdentifier)
    }
  }
  
  //MARK: - Private
  
  /// will load and decode the received json data
  /// - Parameter url: remote url
  /// - Returns: a publisher with the result: T or error
  private func request<T: Codable>(with url: URL) -> AnyPublisher<T, Error> {
    return self.defaultURLSession.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: T.self, decoder: self.decoder)
      .eraseToAnyPublisher()
  }
}
