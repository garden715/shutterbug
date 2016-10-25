//
//  ImageViewController.m
//  Imaginarium
//
//  Created by seojungwon on 2016. 10. 17..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation ImageViewController

- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.scrollView.frame.size : CGSizeZero;
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (UIImageView *) imageView {
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UITapGestureRecognizer *)tapRecognizer{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc]
                          initWithTarget:self action:@selector(handleDoubleTap:)];
    }
    return _tapRecognizer;
}

- (UIImage *) image {
    return self.imageView.image;
}

- (void) setImage:(UIImage *)image {
    self.scrollView.zoomScale = 1.0;
    
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    

    
    // Specify that the gesture must be a single tap
    self.tapRecognizer.numberOfTapsRequired = 2;
    
    // Add the tap gesture recognizer to the view
    [self.scrollView addGestureRecognizer:self.tapRecognizer];
    
}

// when you swipe to left - perform segue with previous photo identifier
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}

- (void) setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self startDownloadingImage];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) startDownloadingImage {
    self.image = nil;
    if (self.imageURL ) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *respone, NSError *error) {
            if(!error) {
                if([request.URL isEqual:self.imageURL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // using resize method - imageWithImage
                        self.image = [self imageWithImage:image scaledToSize:CGSizeMake(self.view.frame.size.width, image.size.height*self.view.frame.size.width/image.size.width)];
                    });
                }
            }
        }];
        [task resume];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
