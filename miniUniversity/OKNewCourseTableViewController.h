//
//  OKNewCourseTableViewController.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKCourse+CoreDataProperties.h"
#import "OKAddTeacherViewController.h"
#import "OKAddStudentsViewController.h"

@interface OKNewCourseTableViewController : UITableViewController <OKAddTeacherViewControllerDelegate,
                                                                   OKAddStudentsViewControllerDelegate>

@property (nonatomic, strong) OKCourse* course;
@property (nonatomic, strong) OKTeacher* delegateTeacher;
@property (nonatomic, strong) NSArray* delegateArrayStudents;

@end
