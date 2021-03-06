//
//  AppLogging.swift
//  collection_view_demo
//
//  Created by AT on 4/8/19.
//  Copyright © 2019 XoXo. All rights reserved.
//

import Foundation
import XCGLogger

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger(identifier: "advanced.logger", includeDefaultDestinations: false)

    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯 ", postfix: " 🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹 ", postfix: " 🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ ", postfix: " ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️ ", postfix: " ⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️ ", postfix: " ‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣 ", postfix: " 💣", to: .severe)
    log.formatters = [emojiLogFormatter]

    #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
        log.remove(destinationWithIdentifier: XCGLogger.Const.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Const.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else

        #if DEBUG
            let level = XCGLogger.Level.verbose
        #else
            let level = XCGLogger.Level.warning
        #endif

        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advanced.logger.system.destination")

        // Optionally set some configuration options
        systemDestination.outputLevel = level
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true

        // Add the destination to the logger
        log.add(destination: systemDestination)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return log
        }
        let logPath: URL = appDelegate.cacheDirectory.appendingPathComponent("monkey.log")
        // Create a file log destination
        let fileDestination = FileDestination(writeToFile: logPath,
                                              identifier: "append.to.existing.log.file",
                                              shouldAppend: true,
                                              appendMarker: "-- Relaunched App --")

        // Optionally set some configuration options
        fileDestination.outputLevel = level
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true

        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue

        // Add the destination to the logger
        log.add(destination: fileDestination)

    #endif

    return log
}()
