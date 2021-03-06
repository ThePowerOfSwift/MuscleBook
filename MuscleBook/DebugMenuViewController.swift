/*
 Muscle Book
 Copyright (C) 2016  Cristian Filipov

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import UIKit
import Eureka
import JSQNotificationObserverKit

class DebugMenuViewController : FormViewController {

    private let db = DB.sharedInstance
    private let mainQueue = NSOperationQueue.mainQueue()
    private var observer: CocoaObserver? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notification = CocoaNotification(name: UIApplicationDidReceiveMemoryWarningNotification)
        observer = CocoaObserver(notification, queue: self.mainQueue, handler: { (notification: NSNotification) in
            self.tableView?.reloadData()
        })

        title = "Debug Menu"

        form

        +++ Section() {
            $0.header = HeaderFooterView(title: "Warning")
            $0.footer = HeaderFooterView(title: "Don't mess with the debug settings unless you know what you are doing.\n\nSome of the options here may cause data loss or other craziness.")
        }

        +++ Section()

        <<< LabelRow() {
            $0.title = "Timers"
        }.cellSetup { cell, row in
            cell.accessoryType = .DisclosureIndicator
        }.onCellSelection { cell, row in
            let vc = DebugTimersViewController()
            self.showViewController(vc, sender: nil)
        }

        <<< LabelRow() {
            $0.title = "Color Palette"
        }.cellSetup { cell, row in
            cell.accessoryType = .DisclosureIndicator
        }.onCellSelection { cell, row in
            let vc = ColorPaletteViewController()
            self.showViewController(vc, sender: nil)
        }

        <<< LabelRow() {
            $0.title = "Anatomy"
        }.cellSetup { cell, row in
            cell.accessoryType = .DisclosureIndicator
        }.onCellSelection { cell, row in
            let vc = AnatomyDebugViewController2()
            self.showViewController(vc, sender: nil)
        }

//        <<< LabelRow("import_csv") {
//            $0.title = "Import CSV"
//            $0.disabled = "$import_csv != nil"
//            $0.hidden = Dropbox.authorizedClient == nil ? true : false
//        }.onCellSelection(onImportCSV)
//
//        <<< LabelRow("sync_dropbox") {
//            $0.title = "Sync Dropbox"
//            $0.disabled = "$sync_dropbox != nil"
//            $0.hidden = Dropbox.authorizedClient == nil ? true : false
//        }.onCellSelection(onSyncWithDropbox)

        +++ Section()

        <<< ButtonRow() {
            $0.title = "Recalculate All Workouts"
            $0.cellUpdate { cell, _ in
                cell.textLabel?.textColor = UIColor.redColor()
            }
            $0.onCellSelection { _, _ in
                WarnAlert(message: "Are you sure? This will be slow and the UI will be unresponsive while calculating.") {
                    try! self.db.recalculateAll()
                }
            }
        }

        <<< ButtonRow() {
            $0.title = "Export Exercises"
            $0.cellUpdate { cell, _ in
                cell.textLabel?.textColor = UIColor.redColor()
            }
            $0.onCellSelection { _, _ in
                let url = NSFileManager
                    .defaultManager()
                    .URLsForDirectory(
                        .CachesDirectory,
                        inDomains: .UserDomainMask
                    )[0]
                    .URLByAppendingPathComponent("exercises.yaml")
                try! self.db.exportYAML(Exercise.self, toURL: url)
                let vc = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: nil
                )
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }

    }

//    private func onSyncWithDropbox(cell: LabelCell, row: LabelRow) {
//        WarnAlert(message: "Are you sure you want to sync?") { _ in
//            row.value = "Syncing..."
//            row.reload()
//            Workset.importFromDropbox("/WorkoutLog.yaml") { status in
//                guard .Success == status else {
//                    Alert(message: "Failed to sync with dropbox")
//                    return
//                }
//                row.value = nil
//                row.disabled = false
//                row.reload()
//                Alert(message: "Sync Complete")
//            }
//        }
//    }

//    private func onImportCSV(cell: LabelCell, row: LabelRow) {
//        guard db.count(Workset) == 0 else {
//            Alert(message: "Cannot import data, you already have data.")
//            return
//        }
//        WarnAlert(message: "Import Data from Dropbox?") { _ in
//            row.value = "Importing..."
//            row.reload()
//            Workset.downloadFromDropbox("/WorkoutLog.csv") { url in
//                guard let url = url else {
//                    row.value = nil
//                    row.reload()
//                    Alert(message: "Failed to import CSV data")
//                    return
//                }
//                row.value = "Importing..."
//                row.reload()
//                do {
//                    let importCount = try self.db.importCSV(Workset.self, fromURL: url)
//                    row.value = nil
//                    row.disabled = false
//                    row.reload()
//                    Alert("Import Complete", message: "\(importCount) records imported.") { _ in
////                        let vc = VerifyWorksetsViewController()
////                        self.presentModalViewController(vc)
//                    }
//                } catch {
//                    row.value = nil
//                    row.reload()
//                    Alert(message: "Failed to import CSV data")
//                    return
//                }
//            }
//        }
//    }

}
