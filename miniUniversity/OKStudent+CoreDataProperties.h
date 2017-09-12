//
//  OKStudent+CoreDataProperties.h
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKStudent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OKStudent (CoreDataProperties)

+ (NSFetchRequest<OKStudent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *mail;
@property (nullable, nonatomic, retain) NSSet<OKCourse *> *course;

@end

@interface OKStudent (CoreDataGeneratedAccessors)

- (void)addCourseObject:(OKCourse *)value;
- (void)removeCourseObject:(OKCourse *)value;
- (void)addCourse:(NSSet<OKCourse *> *)values;
- (void)removeCourse:(NSSet<OKCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
