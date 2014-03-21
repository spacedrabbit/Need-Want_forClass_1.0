//
//  Task.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/21/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "Task.h"


@implementation Task

@dynamic title;
@dynamic date;
@dynamic notes;
@dynamic priority;
@dynamic category;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.date = [NSDate date];
}

@end
