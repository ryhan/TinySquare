//
//  TSQUtilities.m
//  TinySquare
//
//  Created by Tyler Hedrick on 9/2/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import "TSQUtilities.h"
#import <Parse/Parse.h>

@implementation TSQUtilities

+ (void)logNewLocationForCurrentUser:(NSString *)location
{
  PFUser *user = [PFUser currentUser];
  if (!user) {
    NSLog(@"Error, there is no current user");
    return;
  } else if (!location) {
    NSLog(@"Location is nil");
    return;
  }
  [user setObject:location forKey:@"location"];
  [user saveInBackground];
}

+ (void)setLabelToLocationOfLoggedInUser:(UILabel *)label
{
  __block PFUser *user = [PFUser currentUser];
  if (!user) {
    label.text = @"No recent check in.";
    return;
  }
  
  [user refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    user = (PFUser *)object;
    NSString *location = [object objectForKey:@"location"];
    label.text = location ?: @"No recent check in.";
  }];
  
}

@end
