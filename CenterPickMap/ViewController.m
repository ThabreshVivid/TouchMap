//
//  ViewController.m
//  CenterPickMap
//
//  Created by Thabresh on 9/7/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "ViewController.h"
#import "TYPlaceSearchViewController.h"

@interface ViewController ()<TYPlaceSearchViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 1;
    [self.touchMap addGestureRecognizer:tgr];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    TYPlaceSearchViewController *searchViewController = [[TYPlaceSearchViewController alloc] init];
    [searchViewController setDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController animated:YES completion:nil];

}
#pragma mark - ABCGooglePlacesSearchViewControllerDelegate Methods

-(void)searchViewController:(TYPlaceSearchViewController *)controller didReturnPlace:(TYGooglePlace *)place {
    [self.touchMap removeAnnotations:self.touchMap.annotations];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = place.location.coordinate;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",place.location.coordinate.latitude, place.location.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             if (![[greeting objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                 NSDictionary *dic = [[greeting objectForKey:@"results"] objectAtIndex:0];
                 NSString *cityName = [[[dic objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"];
                 NSLog(@"cityName::%@",cityName);
                 myAnnotation.title = cityName;
                 self.txtAddress.text = cityName;
                 MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
                 region.center.latitude = place.location.coordinate.latitude;
                 region.center.longitude = place.location.coordinate.longitude;
                 region.span.longitudeDelta = 0.15f;
                 region.span.latitudeDelta = 0.15f;
                 [self.touchMap setRegion:region animated:YES];
             }
         }
     }];
    [self.touchMap addAnnotation:myAnnotation];
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.touchMap removeAnnotations:mapView.annotations];
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = centre;
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",centre.latitude,centre.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             if (![[greeting objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                 NSDictionary *dic = [[greeting objectForKey:@"results"] objectAtIndex:0];
                 NSString *cityName = [[[dic objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"];
                 myAnnotation.title = cityName;
                 self.txtAddress.text = cityName;
             }
         }
     }];
    [self.touchMap addAnnotation:myAnnotation];
    
}
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.touchMap];
    CLLocationCoordinate2D  coordinate = [self.touchMap convertPoint:touchPoint toCoordinateFromView:self.touchMap];
   
    [self.touchMap removeAnnotations:self.touchMap.annotations];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = coordinate;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",coordinate.latitude,coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             if (![[greeting objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                 NSDictionary *dic = [[greeting objectForKey:@"results"] objectAtIndex:0];
                 NSString *cityName = [[[dic objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"];
                 myAnnotation.title = cityName;
                 self.txtAddress.text = cityName;
             }
         }
     }];
    [self.touchMap addAnnotation:myAnnotation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
