//
//  ViewController.h
//  CenterPickMap
//
//  Created by Thabresh on 9/7/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController<MKMapViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *touchMap;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@end

