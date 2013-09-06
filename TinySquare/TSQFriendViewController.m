//
//  TSQSecondViewController.m
//  TinySquare
//
//  Created by Tyler Hedrick on 8/30/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import "TSQFriendViewController.h"
#import "TSQLocationTableViewCell.h"

@interface TSQFriendViewController ()
@property (nonatomic, strong) NSArray *users;
@end

static NSString * const cellIdentifier = @"TSQLocationTableViewCell";

@implementation TSQFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Friends";
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(tableViewDidRequestRefresh)
                  forControlEvents:UIControlEventValueChanged];
  }
  return self;
}

+ (PFQuery *)queryForTable
{
  PFQuery *query = [PFUser query];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  return query;
}

- (void)loadUsers
{
  PFQuery *query = [[self class] queryForTable];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    self.users = objects;
    [self.refreshControl endRefreshing];
  }];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView registerClass:[TSQLocationTableViewCell class] forCellReuseIdentifier:cellIdentifier];
  [self loadUsers];
}

- (void)setUsers:(NSArray *)users
{
  _users = users;
  [self.tableView reloadData];
}

- (void)tableViewDidRequestRefresh
{
  [self loadUsers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  PFUser *user = [self.users objectAtIndex:indexPath.row];
  NSString *username = [user objectForKey:@"username"];
  NSString *location = [user objectForKey:@"location"];
  cell.textLabel.text = username;
  cell.detailTextLabel.text = location;
  return cell;
}

@end
