//
//  FlickrTableViewController.m
//  Shutterbug
//
//  Created by seojungwon on 2016. 10. 24..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrTableViewController ()

@end

@implementation FlickrTableViewController

- (void) setPhotos: (NSArray *) photos  {
    _photos = photos;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

- (void) prepareImageViewController:(ImageViewController*) ivc toDisplayPhoto:(NSDictionary *)photo {
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath) {
            if([segue.identifier isEqualToString:@"Display Photo"] ) {
                if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
                    id detail = nil;
                    detail = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
                    [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}


@end


