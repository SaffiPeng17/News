//
//  RealmDAO.swift
//  News
//
//  Created by Saffi on 2021/10/11.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class RealmDAO {
    
    typealias CompletionHandler = () -> Void
    
    struct Output {
        let topHeadArticleUpdated = PublishRelay<Void>()
    }
    
    private(set) var output = Output()
    
    init() {
        // get realm file path
        LogHelper.print(.database, item: Realm.Configuration.defaultConfiguration.fileURL?.absoluteString as Any)
    }
}

// MARK: - Interfaces
extension RealmDAO {
    
    // MARK: - Write, Update
    /**
     寫入/更新table data
     
     - Parameters:
        - objects: 要寫入的 data; 單一物件 or Array
        - policy: 操作Policy; .all: 寫入, .modified: 更新; default 為寫入(.all)
        - completion: 更新完成後要執行的工作
     */
    func update<S: Sequence>(_ objects: S, policy: Realm.UpdatePolicy = .all) where S.Iterator.Element: Object {
        DispatchQueue(label: "realm.write.serial.queue").sync {
            autoreleasepool {
                LogHelper.print(.database, item: "update type ", String(describing: S.Element.self))
                guard let realm = try? Realm() else {
                    return
                }
                
                try? realm.write {
                    realm.add(objects, update: policy)
                }
            }
        }
    }
    
    func update<O: Object>(object: O, from id: String, completion: CompletionHandler? = nil) {
        DispatchQueue(label: "realm.write.serial.queue").sync {
            autoreleasepool {
                LogHelper.print(.database, item: "delete only one! ", String(describing: O.self))
                guard let realm = try? Realm(), let obj = realm.object(ofType: O.self, forPrimaryKey: id) else {
                    completion?()
                    return
                }
                
                try? realm.write {
                    realm.delete(obj)
                    realm.add(object, update: .modified)
                }
                completion?()
            }
        }
    }
    
    /**
     查詢 Object.type Table
     
     - Parameters:
        - type: Object.self 要查詢的 table object type
     - Returns: 查詢到的 List-Object
     */
    func read<T: Object>(predicate: String, complete: @escaping ([T]?) -> Void) {
        guard let realm = try? Realm() else {
            complete(nil)
            return
        }

        let result = realm.objects(T.self).filter(predicate)
        guard result.count > 0 else {
            complete(nil)
            return
        }
        _ = result.observe { change in
            switch change {
            case .update:
                self.output.topHeadArticleUpdated.accept(())
            default:
                break
            }
        }
        complete(result.compactMap { $0 })
    }
    
//    func read<T: Object>(predicateFormat: String? = nil, ) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let models = self.getResults(type: T.self, predicateFormat: predicateFormat) else {
//                complete(nil)
//                return
//            }
//
//            LogHelper.print(.database, item: "getModel array type =", String(describing: T.DBObject.self))
//            complete(models.compactMap { T.init(with: $0) })
//        }
//    }
//    
//    func read<T: Object>(predicateFormat: String? = nil, complete: @escaping ([T]?) -> Void) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let models = self.getResults(type: T.self, predicateFormat: predicateFormat) else {
//                complete(nil)
//                return
//            }
//
//            LogHelper.print(.database, item: "getModel array type =", String(describing: T.DBObject.self))
//            complete(models.compactMap { T.init(with: $0) })
//        }
//    }
//    
//    func observe<T: Object>(predicateFormat: String) -> Observable<T> {
//        return Observable<T>.create { observer in
//            guard let realm = try? Realm() else {
//                return Disposables.create()
//            }
//            var result = realm.objects(T.self)
//            
////            guard result.count > 0 else {
////                return nil
////            }
////
////            guard let predicate = predicateFormat else {
////                return result
////            }
////
////            return result.filter(predicate)
////
////            var results = realm.objects(MyRealmObject.self).filter: "userID == \(someID)")
//            var notificationToken = result.observe { change in
//                switch change {
//                case .
//                }
////                switch change {
////                case .update:
////                    observer.onNext()
////                default: ()
////                }
//            }
//            
//            return Disposables.create()
//        }
//    }
//    
//    func getModels<T: ModelPotocol>(type: T.Type, predicateFormat: String? = nil, complete: @escaping ([T]?) -> Void) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let models = self.getResults(type: T.DBObject.self, predicateFormat: predicateFormat) else {
//                complete(nil)
//                return
//            }
//
//            LogHelper.print(.database, item: "getModel array type =", String(describing: T.DBObject.self))
//            complete(models.compactMap { T.init(with: $0) })
//        }
//    }
//    
//    func observe<T:>() -> Observe<> {
//        guard let realm = try? Realm(), let obj = realm.object(ofType: type, forPrimaryKey: id) else {
//            completion?()
//            return
//        }
//        
//        try? realm.write {
//            realm.delete(obj)
//        }
//        completion?()
//
//        var results = realm.objects(MyRealmObject.self).filter: "userID == \(someID)")
//
//        var notificationToken = results.observe { change in
//            switch change {
//            case .update:
//                DispatchQueue.main.async {
//                    block()
//                }
//            default: ()
//            }
//        }
//    }
}

private extension RealmDAO {
    /**
     查詢 Object.type Table
     
     - Parameters:
        - type: Object.self 要查詢的 table object type
     - Returns: 查詢到的 List-Object
     */
    func getResults<O: Object>(type: O.Type, predicateFormat: String? = nil) -> Results<O>? {
        guard let realm = try? Realm() else {
            return nil
        }
        
        let result = realm.objects(type) as Results<O>
        guard result.count > 0 else {
            return nil
        }
        
        guard let predicate = predicateFormat else {
            return result
        }
        
        return result.filter(predicate)
    }
    
    /**
     查詢 Object.type Table
     
     - Parameters:
        - type: Object.self 要查詢的 table object type
        - id: Object 的 primaryKey "_id"
     - Returns: 查詢到的 Results (只會有一筆)
     */
    func getResult<O: Object>(type: O.Type, by id: String) -> O? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.object(ofType: type, forPrimaryKey: id)
    }
}
//
//// MARK: - new one
//extension RealmDAO {
//    func getModel<T: ModelPotocol>(type: T.Type, id: String, complete: @escaping (T?) -> Void) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let model = self.getResult(type: T.DBObject.self, by: id) else {
//                complete(nil)
//                return
//            }
//
//            LogHelper.print(.database, item: "getModel type = ", String(describing: T.DBObject.self))
//            complete(T.init(with: model))
//        }
//    }
//
//    func getModels<T: ModelPotocol>(type: T.Type, predicateFormat: String? = nil, complete: @escaping ([T]?) -> Void) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let models = self.getResults(type: T.DBObject.self, predicateFormat: predicateFormat) else {
//                complete(nil)
//                return
//            }
//
//            LogHelper.print(.database, item: "getModel array type =", String(describing: T.DBObject.self))
//            complete(models.compactMap { T.init(with: $0) })
//        }
//    }
//
//    func getDraftMessages(predicateFormat: String, complete: @escaping ([RLMDraftMessage]) -> Void) {
//        DispatchQueue(label: "realm.write.serial.queue").async {
//            guard let messages = self.getResults(type: RLMDraftMessage.self, predicateFormat: predicateFormat) else {
//                complete([])
//                return
//            }
//            complete(messages.toArray())
//        }
//    }
//
//    func immediatelyModel<T: ModelPotocol>(type: T.Type, id: String) -> T? {
//        guard let model = self.getResult(type: T.DBObject.self, by: id) else {
//            return nil
//        }
//
//        return T.init(with: model)
//    }
//
//    func immediatelyModels<T: ModelPotocol>(type: T.Type, predicateFormat: String? = nil) -> [T]? {
//        guard let models = self.getResults(type: T.DBObject.self, predicateFormat: predicateFormat) else {
//            return nil
//        }
//
//        return models.compactMap { T.init(with: $0) }
//    }
//}
