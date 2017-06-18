//
//  ViewController.m
//  CouponsDelivery
//
//  Created by Gu Han on 6/18/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"
#import "MyAnnotation.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *userAnno;
@property (nonatomic, assign) BOOL mapIsMoving;
@property (strong, nonatomic) CLCircularRegion *rocketSellerRegion;
@property (strong, nonatomic) MyAnnotation *rocketSellerAnno;
@end

@implementation ViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.mapIsMoving = NO;
  
  [self setUpRocketSellerRegion];
  [self setUpLocationManager];
  [self addUserAnno];
  [self addRocketSellerAnno];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if([annotation isKindOfClass:[MyAnnotation class]]) {
    MyAnnotation *myLocation = (MyAnnotation *)annotation;
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    if (annotationView == nil) {
      annotationView = myLocation.annotationView;
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  } else {
    return nil;
  }
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
  [self.locationManager startMonitoringForRegion:self.rocketSellerRegion];
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

#pragma mark - RocketSellerRegion

- (void) setUpRocketSellerRegion {
  self.rocketSellerRegion = [[CLCircularRegion alloc]
                             initWithCenter:CLLocationCoordinate2DMake(37.408892, -122.064457)
                             radius:10
                             identifier:@"RocketSellerRegionIdentifier"];
}

-(void) addRocketSellerAnno {
  self.rocketSellerAnno = [[MyAnnotation alloc] initWithTitle:@"Rocket Seller"
                                                     Location:CLLocationCoordinate2DMake(37.408892, -122.064457)];
  [self.mapView addAnnotation:self.rocketSellerAnno];
  
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  // TO DO: pop up notification offering the user a coupon code

}

@end
