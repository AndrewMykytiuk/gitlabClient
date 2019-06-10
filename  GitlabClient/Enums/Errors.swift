//
//  Errors.swift
//  GitlabClient
//
//  Created by User on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

enum ParsingError: Error {
    case wrongEnterData(_ data: Data)
    case wrongProccessing(_ string: String)
    case wrongInstrumentsFor(_ string: String)
    case emptyResult(_ string: String?)
}

enum NetworkError: Error {
    case invalidUrl(_ string: String)
    case invalidRequest(_ request: Request)
    case invalidReceivedData(_ data: Data)
}

enum KeychainError: Error {
    case noPassword(_ string: String)
    case unexpectedPasswordString(_ string: String?)
    case unexpectedItemData(_ data: Data)
    case unhandledError(_ string: String)
}

enum GitLabError {
    
    enum NetworkConnection: String, Error {
        case reachabilityError = "No network connection"
    }
    
    enum Storyboard: String, Error {
         case invalidStoryboardCreate = "Cannot create View storyboard"
    }
    
    enum CellCreation: String, Error {
        case invalidCellCreate = "The dequeued cell is not an instance of "
    }
    
    enum CoreDataStack: String, Error {
        case saveFailed = "Failed to save into context with error: "
        case persistantContainerLoadFailed = "Failed to load container with error: "
        case fetchFailed = "Failed to fetch from context with error: "
        case deleteFailed = "Failed to delete from context with error: "
    }
    
    enum CoreDataEntityMapper: String, Error {
        case failedProjectMap = "Failed to map Project from entity"
        case failedMergeRequestMap = "Failed to map MergeRequest from entity"
        case failedUserMap = "Failed to map User from entity"
    }
    
    enum CoreDataEntityCreation: String, Error {
        case failedProject = "Failed to create ProjectEntity"
        case failedMergeRequest = "Failed to create MergeRequestEntity"
        case failedUser = "Failed to create UserEntity"
    }
    
    enum CoreDataEntityDowncast: String, Error {
        case failedProjectEntities = "Failed to downcast ProjectEntities from ManagedObjects"
        case failedMergeRequestEntities = "Failed to map MergeRequestEntities from ManagedObjects"
        case failedUserEntities = "Failed to map UserEntities from ManagedObjects"
    }
    
}

enum CodeError: Int, Error {
    case requestTimeout
    
    var range:Range<Int> {
        switch self {
        case .requestTimeout : return -1011 ..< -1000
        }
    }
}

