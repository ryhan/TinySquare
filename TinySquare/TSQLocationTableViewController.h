//
//  TSQLocationTableViewController.h
//  TinySquare
//
//  Created by Tyler Hedrick on 8/30/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@class TSQLocation;

@interface TSQLocationTableViewController : UITableViewController

@property (nonatomic, strong) CLLocation *location;

- (instancetype)initWithLocation:(CLLocation *)location;

@end
