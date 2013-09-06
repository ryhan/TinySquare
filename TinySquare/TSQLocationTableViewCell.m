//
//  TSQLocationTableViewCell.m
//  TinySquare
//
//  Created by Tyler Hedrick on 8/31/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import "TSQLocationTableViewCell.h"

@implementation TSQLocationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  if (selected) {
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    self.accessoryType = UITableViewCellAccessoryNone;
  }
}

@end
