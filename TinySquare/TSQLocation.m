//
//  TSQLocation.m
//  TinySquare
//
//  Created by Tyler Hedrick on 8/30/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import "TSQLocation.h"
#import <CoreLocation/CoreLocation.h>

@implementation TSQLocation

- (instancetype)initWithCLLocation:(CLLocation *)location
                              name:(NSString *)name
                          distance:(NSInteger)distance
{
  if (self = [super init]) {
    self.location = location;
    self.name = name;
    self.distance = distance;
  }
  return self;
}

@end
