//
//  NSDateFormatter+NWForm.m
//  Need-Want_forClass_1.0
//
//  Created by Louis Tur on 3/22/14.
//  Copyright (c) 2014 Louis Tur. All rights reserved.
//

#import "NSDateFormatter+NWForm.h"

@implementation NSDateFormatter (NWForm)

+(NSDateFormatter *)nwsDateForm{
    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd/MM/yyyy"];
    
    return fm;
}

@end
