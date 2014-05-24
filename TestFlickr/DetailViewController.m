

//
//  DetailViewController.m
//  TestFlickr
//
//  Created by Anshul on 5/24/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *authorID;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
- (IBAction)backBtnCLicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView.contentSize = CGSizeMake(320, 2000);
    
    _imageTitle.text = _flickrInfoObjcet.title;
    _author.text = _flickrInfoObjcet.author;
    _tags.text = _flickrInfoObjcet.tags;
    _authorID.text = _flickrInfoObjcet.author_id;
    [_imageView setImageWithURL:[NSURL URLWithString:_flickrInfoObjcet.urlLink]];
    [_descriptionWebView loadHTMLString:_flickrInfoObjcet.description baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnCLicked:(id)sender {
    [self.view removeFromSuperview];
}
@end
