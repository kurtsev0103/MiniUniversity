//
//  OKStudent+CoreDataProperties.m
//  Homework_CoreData
//
//  Created by Oleksandr Kurtsev on 01.09.17.
//  Copyright © 2017 Oleksandr Kurtsev. All rights reserved.
//

#import "OKStudent+CoreDataProperties.h"

@implementation OKStudent (CoreDataProperties)

+ (NSFetchRequest<OKStudent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OKStudent"];
}

@dynamic firstName;
@dynamic gender;
@dynamic lastName;
@dynamic mail;
@dynamic course;

@end
