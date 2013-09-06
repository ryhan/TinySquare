//
//  TSQUtilities.h
//  TinySquare
//
//  Created by Tyler Hedrick on 9/2/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSQUtilities : NSObject

+ (void)logNewLocationForCurrentUser:(NSString *)location;
+ (void)setLabelToLocationOfLoggedInUser:(UILabel *)label;

@end
