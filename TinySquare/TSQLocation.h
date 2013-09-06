//
//  TSQLocation.h
//  TinySquare
//
//  Created by Tyler Hedrick on 8/30/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface TSQLocation : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger distance;

- (instancetype)initWithCLLocation:(CLLocation *)location
                              name:(NSString *)name
                          distance:(NSInteger)distance;

@end
