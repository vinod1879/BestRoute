//
//  BRViewController.m
//  BestRoute
//
//  Created by Vinod Vishwanath on 11/11/13.
//  Copyright (c) 2013 Vinod Vishwanath. All rights reserved.
//

#import "BRViewController.h"

@interface BRViewController ()

@end

@implementation coords


@end

@implementation BRViewController


#define MAPS_API_URL @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&mode=driving"

#define INFI 9999
#define MAXNODES 11

NSString * const FormatType_toString[] = {
    [Bangalore] = @"Bangalore",
    [Hyderabad] = @"Hyderabad",
    [Chennai] = @"Chennai",
    [Vishakhapatnam] = @"Vishakhapatnam",
    [Bhubaneswar] = @"Bhubaneswar",
    [Kolkata] = @"Kolkata",
    [Nagpur] = @"Nagpur",
    [Ranchi] = @"Ranchi",
    [Rourkela] = @"Rourkela",
    [Raipur] = @"Raipur",
    [Vijayawada] = @"Vijayawada"
    
};
// To convert enum to string:


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GMSServices provideAPIKey:@"AIzaSyDjLz4bc9GfsJhn-JAkqVieKBozQvXiXCE"];
    [self initMap];
    
    activityView = [[BRActivityView alloc] initWithParentView:self.view];
    
    coordArray = [[NSMutableArray alloc] initWithCapacity:MAXNODES];
    
    for(int i=0; i<MAXNODES; i++) {
        
        coords *obj = [[coords alloc] init];
        obj.lat = obj.lng = 0;
        [coordArray addObject:obj];
    }
    
    [self setAvailabilityMatrix];
    
    [activityView startAnimating];
    [self performSelectorInBackground:@selector(setCostMatrix) withObject:nil];
}


-(IBAction)calculateRoute:(id)sender
{
    if([activityView isAnimating])
    {
        [self showAlertWithTitle:@"" message:@"Please wait till initialization completes"];
        return;
    }
    
    int s, d;
    
    s = [self.pickerView selectedRowInComponent:0];
    d = [self.pickerView selectedRowInComponent:1];
    
    if(s != d) {
        
        [self shortPathWithSource:s destination:d];
    }
    else {
        
        [self showAlertWithTitle:@"" message:@"Please select a destination different from the origin"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setAvailabilityMatrix
{
    [self setAvailabilityWithSource:Bangalore destination:Hyderabad availability:YES];
    [self setAvailabilityWithSource:Bangalore destination:Chennai availability:YES];
    [self setAvailabilityWithSource:Bangalore destination:Nagpur availability:YES];
    
    [self setAvailabilityWithSource:Hyderabad destination:Chennai availability:YES];
    [self setAvailabilityWithSource:Hyderabad destination:Vishakhapatnam availability:YES];
    [self setAvailabilityWithSource:Hyderabad destination:Nagpur availability:YES];
    [self setAvailabilityWithSource:Hyderabad destination:Ranchi availability:YES];
    [self setAvailabilityWithSource:Hyderabad destination:Raipur availability:YES];
    [self setAvailabilityWithSource:Hyderabad destination:Vijayawada availability:YES];
    
    [self setAvailabilityWithSource:Chennai destination:Vishakhapatnam availability:YES];
    [self setAvailabilityWithSource:Chennai destination:Vijayawada availability:YES];
    
    
    [self setAvailabilityWithSource:Vishakhapatnam destination:Bhubaneswar availability:YES];
    [self setAvailabilityWithSource:Vishakhapatnam destination:Ranchi availability:YES];
    [self setAvailabilityWithSource:Vishakhapatnam destination:Rourkela availability:YES];
    [self setAvailabilityWithSource:Vishakhapatnam destination:Raipur availability:YES];
    [self setAvailabilityWithSource:Vishakhapatnam destination:Vijayawada availability:YES];
    
    [self setAvailabilityWithSource:Bhubaneswar destination:Kolkata availability:YES];
    [self setAvailabilityWithSource:Bhubaneswar destination:Rourkela availability:YES];
    [self setAvailabilityWithSource:Bhubaneswar destination:Raipur availability:YES];
    
    [self setAvailabilityWithSource:Kolkata destination:Ranchi availability:YES];
    [self setAvailabilityWithSource:Kolkata destination:Rourkela availability:YES];
    [self setAvailabilityWithSource:Kolkata destination:Raipur availability:YES];
    
    [self setAvailabilityWithSource:Nagpur destination:Raipur availability:YES];
    
    [self setAvailabilityWithSource:Ranchi destination:Rourkela availability:YES];
    [self setAvailabilityWithSource:Ranchi destination:Raipur availability:YES];
    
    [self setAvailabilityWithSource:Rourkela destination:Raipur availability:YES];
    
}

-(void)setCostMatrix
{
    for(int i=0; i<11; i++)
    {
        for(int j=0; j<11; j++)
        {
            if(i==j)
                break;
            
            if(aMatrix[i][j] == 0) {
                
                [self setCostWithSource:i destination:j cost:INFI];
            }
            else {
                
                [self calculateDrivingDistanceForSource:i destination:j];
            }
        }
    }
    
    [activityView stopAnimating];
}


-(void)calculateDrivingDistanceForSource:(CityList)source destination:(CityList)destination
{
    NSString *urlStr = [NSString stringWithFormat:MAPS_API_URL, FormatType_toString[source], FormatType_toString[destination]];
    
    if(source == Vijayawada && destination == Vishakhapatnam) {
        
    }
    NSLog(@"\nCalculating %@ to %@ \n", FormatType_toString[source], FormatType_toString[destination]);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSURLResponse *response;
    NSError *error;

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    int distance = [[[[[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"] intValue];
    
    float oLat, oLng, dLat, dLng;
    
    
    oLat = [[[[[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_location"] objectForKey:@"lat"] floatValue];
    
    oLng = [[[[[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_location"] objectForKey:@"lng"] floatValue];
    
    dLat = [[[[[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"end_location"] objectForKey:@"lat"] floatValue];
    
    dLng = [[[[[[[dict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"end_location"] objectForKey:@"lng"] floatValue];
    
    distance/=1000;
    
    NSLog(@"\nDistance %@ to %@ is %d\n", FormatType_toString[source], FormatType_toString[destination], distance);
    
    [self setCostWithSource:source destination:destination cost:distance];
    
    coords *startCoord = [[coords alloc] init];
    coords *endCoord = [[coords alloc] init];
    
    startCoord.lat = oLat;
    startCoord.lng = oLng;
    
    endCoord.lat = dLat;
    endCoord.lng = dLng;
    
    [coordArray replaceObjectAtIndex:source withObject:startCoord];
    [coordArray replaceObjectAtIndex:destination withObject:endCoord];
}


-(void)shortPathWithSource:(int)s destination:(int)t
{
    int pd;
    int precede[MAXNODES];
    int distance[MAXNODES],perm[MAXNODES];
    int current,i,k,dc;
    int smalldist,newdist;

    // init perm and distance array
    for(i=0;i<MAXNODES;i++)
    {
        perm[i]=0;
        distance[i]=INFINITY;
    }
    perm[s] = 1;
    distance[s] = 0;
    current = s;
    while(current != t)
    {
        smalldist=INFINITY;
        dc=distance[current];
        for(i=0;i<MAXNODES;i++) {
            if(perm[i]==0)
            {
                newdist = dc + cMatrix[current][i];
                if(newdist < distance[i])
                {
                    distance[i]=newdist;
                    precede[i]=current;
                }
                if(distance[i] < smalldist)
                {
                    smalldist = distance[i];
                    k=i;
                }
            }
        }
        
        current = k;
        perm[current]=1;
    }
    pd=distance[t];
    
    
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    current = t;
    
    while (current != s) {
       
        [pathArray addObject:[NSNumber numberWithInt:current]];
        current = precede[current];
    }
    
    [pathArray addObject:[NSNumber numberWithInt:current]];
    [self plotMapWithArray:pathArray];
    NSLog(@"\n\nShortest Distance: %d", pd);
}

-(void)initMap
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:20
                                                            longitude:77
                                                                 zoom:4];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 250, 320, 250) camera:camera];
    
    [self.view addSubview:mapView];
}

-(void)plotMapWithArray:(NSArray*)array
{
    if(previousPath != nil)
    {
        previousPath.map = nil;
    }
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (NSNumber *num in array) {
        
        coords *current = [coordArray objectAtIndex:[num intValue]];
        [path addLatitude:current.lat longitude:current.lng];
        
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;
    
    previousPath = polyline;
}


-(void)setAvailabilityWithSource:(CityList)start destination:(CityList)destination availability:(BOOL)availability
{
    aMatrix[start][destination] = (availability)?1:0;
    aMatrix[destination][start] = (availability)?1:0;
    
}

-(void)setCostWithSource:(CityList)start destination:(CityList)destination cost:(int)cost
{
    cMatrix[start][destination] = cost;
    cMatrix[destination][start] = cost;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return MAXNODES;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 37)];
    label.text = FormatType_toString[row];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    return label;
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];
}

@end
