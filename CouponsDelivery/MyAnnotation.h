//
//  MyAnnotation.h
//  CouponsDelivery
//
//  Created by Gu Han on 6/18/17.
//  Copyright © 2017 Gu Han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface MyAnnotation : NSObject <MKAnnotation> {
  CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordiante;
@property (copy, nonatomic) NSString *title;

- (id) initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *) annotationView;


@end
