//
//  OKAddStudentsViewController.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 30.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OKCourse;

@protocol OKAddStudentsViewControllerDelegate

@property (nonatomic, strong) NSArray* delegateArrayStudents;

@end

@interface OKAddStudentsViewController : UIViewController

@property (weak, nonatomic) id <OKAddStudentsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* allStudentsOnCourse;

@end
