//
//  JustPostedFlickrPhotosViewController.m
//  Shutterbug
//
//  Created by seojungwon on 2016. 10. 24..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

#import "JustPostedFlickrPhotosViewController.h"
#import "FlickrFetcher.h"

@implementation JustPostedFlickrPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
}

- (void)fetchPhotos {
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];

    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    NSLog(@"Flickr result =%@", propertyListResults);
    NSArray *photos = [[propertyListResults valueForKey:@"photos"]valueForKey:@"photo"];
    
    self.photos = photos;
}

@end
