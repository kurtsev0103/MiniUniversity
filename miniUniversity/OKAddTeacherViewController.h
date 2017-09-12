//
//  OKAddTeacherViewController.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 30.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OKTeacher;

@protocol OKAddTeacherViewControllerDelegate

@property (nonatomic, strong) OKTeacher* delegateTeacher;

@end


@interface OKAddTeacherViewController : UIViewController

@property (weak, nonatomic) id <OKAddTeacherViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) OKTeacher* teacher;

@end
