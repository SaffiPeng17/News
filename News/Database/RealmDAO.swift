//
//  RealmDAO.swift
//  News
//
//  Created by Saffi on 2021/10/11.
//

import Foundation
import RealmSwift

class RealmDAO {

    init() {
        // get realm file path
        LogHelper.print(.database, item: Realm.Configuration.defaultConfiguration.fileURL?.absoluteString as Any)
    }
}

// MARK: - Interfaces
extension RealmDAO {
    /**
     建立/更新Object data
     
     - Parameters:
        - objects: 要寫入的 data; 單一物件 or Array
        - policy: 操作Policy; .all: 寫入, .modified: 更新; default 為寫入(.all)
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

    /**
     讀取Object data
     
     - Parameters:
        - type: 要讀取的 Object data type
        - predicate: 讀取的條件; e.g.: "id=12345"
     - Returns:
        回傳查詢結果
     */
    func read<O: Object>(type: O.Type, predicate: String? = nil) -> Results<O>? {
        guard let realm = try? Realm() else {
            return nil
        }
        
        let result = realm.objects(O.self)
        guard let predicate = predicate else {
            return result
        }
        return result.filter(predicate)
    }
}
