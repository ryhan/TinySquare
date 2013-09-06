//
//  TSQLocationTableViewController.m
//  TinySquare
//
//  Created by Tyler Hedrick on 8/30/13.
//  Copyright (c) 2013 hedrick.tyler. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TSQLocationTableViewController.h"
#import "TSQLocationTableViewCell.h"
#import "TSQLocation.h"

static NSString * const kClientId = @"OCZGE1NGZJUFM4GFQQTONGWSZQBRSPMF1HTCGA5LPBDIVV5E";
static NSString * const kClientSecret = @"5XDP4F3WRTNJWTCIDFCNWRNTT3RT5DCDU0MUFLFQ1Z2FCP14";
static NSString * const kFoursquareEndpoint = @"https://api.foursquare.com/v2/venues/search";
static NSString * const cellIdentifier = @"LocationTableViewCell";

@interface TSQLocationTableViewController ()
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) TSQLocation *checkinLocation;
@end

@implementation TSQLocationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  @throw [NSException exceptionWithName:@"TSQLocationTableViewControllerNotDesignatedInitializer"
                                 reason:@"Please use initWithLocation: instead"
                               userInfo:nil];
}

- (instancetype)initWithLocation:(CLLocation *)location
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    self.location = location;
    self.title = @"Nearby";
  }
  return self;
}

#pragma mark -
#pragma mark IMPLEMENT THESE METHODS
// You may not need to change both for a correct implementation

- (void)cancelPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkInPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

// END IMPLEMENTATION

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self findLocations];
  [self.tableView registerClass:[TSQLocationTableViewCell class] forCellReuseIdentifier:cellIdentifier];
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelPressed:)];
  
  UIBarButtonItem *checkInButton = [[UIBarButtonItem alloc] initWithTitle:@"Check In"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(checkInPressed:)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = checkInButton;
}

- (TSQLocation *)locationWithContentsOfDictionary:(NSDictionary *)dict
{
  NSDictionary *locationDictionary = [dict objectForKey:@"location"];
  CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[locationDictionary objectForKey:@"lat"] doubleValue]
                                               longitude:[[locationDictionary objectForKey:@"lng"] doubleValue]];
  TSQLocation *location = [[TSQLocation alloc] initWithCLLocation:loc
                                                             name:[dict objectForKey:@"name"]
                                                         distance:[[locationDictionary objectForKey:@"distance"] integerValue]];
  
  return location;
}

- (void)findLocations
{
  CLLocationDegrees lat = self.location.coordinate.latitude;
  CLLocationDegrees lng = self.location.coordinate.longitude;
  NSString *endpoint = [NSString stringWithFormat:@"%@?ll=%.5f,%.5f&client_id=%@&client_secret=%@&intent=browse&radius=1000",
                        kFoursquareEndpoint,
                        lat,
                        lng,
                        kClientId,
                        kClientSecret];
  // punt to background thread
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error;
    NSError *JSONerror;
    NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:endpoint] options:0 error:&error];
    if (error) {
      NSLog(@"Data read encountered error %@", error);
    }
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result
                                                               options:0
                                                                 error:&JSONerror];
    if (JSONerror) {
      NSLog(@"Reading data to JSON encountered error %@", JSONerror);
    }
    NSArray *places = [[[[resultDict objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:places.count];
    [places enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
      array[idx] = [self locationWithContentsOfDictionary:dict];
    }];
    
    [array sortUsingComparator:^NSComparisonResult(TSQLocation *obj1, TSQLocation *obj2) {
      return obj1.distance - obj2.distance;
    }];
    self.locations = [array copy];
    array = nil;
    
    // reload table on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TSQLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  TSQLocation *location = (TSQLocation *)[self.locations objectAtIndex:indexPath.row];
  cell.textLabel.text = location.name;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %dm", location.distance];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  self.checkinLocation = self.locations[indexPath.row];
}

@end
