//
//  NSDictionary+ObjectForKeyOrNil.m
//  Collaboration
//
//  Created by Danish Ahmed Ansari on 22/10/13.
//  Copyright (c) 2013 Danish Ahmed Ansari. All rights reserved.
//  Email - mail.danishaa@gmail.com

#import "NSDictionary+ObjectForKeyOrNil.h"

@implementation NSDictionary (ObjectForKeyOrNil)

- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    if ([val isEqual:[NSNull null]]) {
        return nil;
    }
    
    return val;
}

@end
