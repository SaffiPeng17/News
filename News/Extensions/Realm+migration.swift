//
//  Realm+migration.swift
//  News
//
//  Created by Saffi on 2021/10/11.
//

import Foundation
import RealmSwift

extension Realm {
    /**
     確認＆更新Realm的Schema
     */
    static func migration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: AppConfig.Realm.schemaVersion,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    LogHelper.print(.database, item: "initial Realm")
                }
            }
        )
    }
}
