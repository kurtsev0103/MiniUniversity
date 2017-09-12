//
//  OKNewTeacherTableViewController.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKTeacher+CoreDataProperties.h"

@interface OKNewTeacherTableViewController : UITableViewController

@property (nonatomic, strong) OKTeacher* teacher;

@end
