//
//  OKNewStudentTableViewController.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 28.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKStudent+CoreDataProperties.h"

@interface OKNewStudentTableViewController : UITableViewController

@property (nonatomic, strong) OKStudent* student;

@end
