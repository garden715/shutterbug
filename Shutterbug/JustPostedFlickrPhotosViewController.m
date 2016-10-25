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

- (IBAction)fetchPhotos {
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSLog(@"Flickr result =%@", propertyListResults);
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

@end
