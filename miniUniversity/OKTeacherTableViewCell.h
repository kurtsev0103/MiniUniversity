//
//  OKTeacherTableViewCell.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 29.08.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OKTeacherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCourse;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@end
