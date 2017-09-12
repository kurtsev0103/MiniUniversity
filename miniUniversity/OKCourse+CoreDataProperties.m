//
//  OKCourse+CoreDataProperties.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKCourse+CoreDataProperties.h"

@implementation OKCourse (CoreDataProperties)

+ (NSFetchRequest<OKCourse *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OKCourse"];
}

@dynamic courseName;
@dynamic disciplineName;
@dynamic student;
@dynamic teacher;

@end
