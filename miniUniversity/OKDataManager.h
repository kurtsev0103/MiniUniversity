//
//  OKDataManager.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 28.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface OKDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (OKDataManager*)sharedManager;

- (void)generateAndAddRandomDataBase;
- (void)deleteAllObjects;
- (void)printAllObjects;

@end
