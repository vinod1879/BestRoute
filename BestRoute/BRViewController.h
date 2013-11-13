//
//  BRViewController.h
//  BestRoute
//
//  Created by Vinod Vishwanath on 11/11/13.
//  Copyright (c) 2013 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BRActivityView.h"

@interface coords:NSObject

@property float lat;
@property float lng;
@property NSString* encodedPath;

@end

@interface BRViewController : UIViewController {
    
    int aMatrix[12][12];
    int cMatrix[12][12];
    NSMutableArray *coordArray;
    GMSMapView *mapView;
    BRActivityView *activityView;
    
    GMSPolyline *previousPath;
    NSMutableDictionary *routePath;
    
}

@property IBOutlet UIPickerView *pickerView;

-(IBAction)calculateRoute:(id)sender;

typedef enum CityList {
    Bangalore =0,
    Hyderabad,
    Chennai,
    Vishakhapatnam,
    Bhubaneswar,
    Kolkata,
    Nagpur,
    Ranchi,
    Rourkela,
    Raipur,
    Vijayawada
} CityList;

extern NSString * const FormatType_toString[];



@end
