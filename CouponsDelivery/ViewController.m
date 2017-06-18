//
//  ViewController.m
//  CouponsDelivery
//
//  Created by Gu Han on 6/18/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *userAnno;
@property (nonatomic, assign) BOOL mapIsMoving;
@end

@implementation ViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.mapIsMoving = NO;
  
  [self setUpLocationManager];

  [self addUserAnno];
  [self zoomTheMap];

  
}

#pragma mark - MapView

- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  self.mapIsMoving = YES;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  self.mapIsMoving = NO;
}

- (void) centerMap: (MKPointAnnotation *)centerPoint{
  [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

- (void) zoomTheMap {
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.userAnno.coordinate, 500, 500);
  MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
  [self.mapView setRegion:adjustedRegion animated:YES];
}

#pragma mark - LocationManager

- (void) setUpLocationManager {
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.allowsBackgroundLocationUpdates = YES;
  self.locationManager.pausesLocationUpdatesAutomatically = YES;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.distanceFilter = 1; // meters
  [self.locationManager requestAlwaysAuthorization];
  self.mapView.showsUserLocation = YES;
  [self.locationManager startUpdatingLocation];
}

- (void) addUserAnno {
  self.userAnno = [[MKPointAnnotation alloc] init];
  self.userAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
  self.userAnno.title = @"My location!";

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  self.userAnno.coordinate = locations.lastObject.coordinate;
  if (self.mapIsMoving == NO) {
    [self centerMap:self.userAnno];
  }
}


@end
