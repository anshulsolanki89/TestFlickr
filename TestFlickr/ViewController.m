//
//  ViewController.m
//  TestFlickr
//
//  Created by Anshul on 5/22/14.
//  Copyright (c) 2014 Anshul. All rights reserved.
//

#import "ViewController.h"
#import "TestFlickrApiManager.h"
#import "TestFlickrDataTranslator.h"
#import "FlickrInfo.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)DetailViewController *dvc;
@property (nonatomic,strong) NSArray *flickrDataArray;
@property (nonatomic,strong )UIRefreshControl *refreshControl;

- (IBAction)sortByDate:(id)sender;
- (IBAction)sortByTitle:(id)sender;
- (IBAction)sortByAuthor:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];

    [self fetchDataFromServer];
}

-(void)fetchDataFromServer {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        
        [TestFlickrApiManager getDataFromFlickrApiWithCallBack:^(BOOL response, id result) {
            
            if (response) {
                
                if ([result isKindOfClass:[NSDictionary class]]) {
                    
                    TestFlickrDataTranslator *dataTranslator = [[TestFlickrDataTranslator alloc] init];
                    [dataTranslator parseDataFlickrApi:result withCallBack:^(id parseData) {
                        
                        if ([parseData isKindOfClass:[NSArray class]]) {
                            if ([parseData count] > 0) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    _flickrDataArray = [NSArray arrayWithArray:parseData];
                                    [_tableView reloadData];
                                });
                            }
                        }
                    }];
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alertView show];
                    });
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                });
            }
        }];
    });
}

-(void)updateData {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    
    
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    [self fetchDataFromServer];
    
    [self.refreshControl endRefreshing];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        
        _flickrDataArray = nil;
    }
    
}

#pragma mark -TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_flickrDataArray count]>0?[_flickrDataArray count]:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_flickrDataArray count]>0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
        [imageView setImageWithURL:[NSURL URLWithString:((FlickrInfo *)[_flickrDataArray objectAtIndex:indexPath.row]).urlLink] ];
        
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:102];
        title.text = ((FlickrInfo *)[_flickrDataArray objectAtIndex:indexPath.row]).title;
        
        UILabel *author = (UILabel *)[cell.contentView viewWithTag:103];
        author.text = ((FlickrInfo *)[_flickrDataArray objectAtIndex:indexPath.row]).author;
        
        UILabel *date = (UILabel *)[cell.contentView viewWithTag:104];
        date.text = ((FlickrInfo *)[_flickrDataArray objectAtIndex:indexPath.row]).date;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString *CellIdentifierNoData = @"CellIdentifierNoData";
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifierNoData];
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierNoData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"NO DATA AVAILABLE";
        
        return cell;
    }
}

#pragma mark- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_flickrDataArray count]>0) {
        if (_dvc == nil) {
            _dvc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
        } else {
            _dvc = nil;
            _dvc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
        }
        _dvc.flickrInfoObjcet = ((FlickrInfo *)[_flickrDataArray objectAtIndex:indexPath.row]);
        [self.view addSubview:_dvc.view];
    }
   
}

#pragma mark - Sorting
- (IBAction)sortByDate:(id)sender {
    
    if ([self isDataExistsToSort]) {
        
        TestFlickrDataTranslator *dataTranslator = [[TestFlickrDataTranslator alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
            [dataTranslator sortArrayByDate:_flickrDataArray withCallBack:^(id parseData) {
                _flickrDataArray = [NSArray arrayWithArray:parseData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }];
        });
    }
}

- (IBAction)sortByTitle:(id)sender {
    
    if ([self isDataExistsToSort]) {
        
        TestFlickrDataTranslator *dataTranslator = [[TestFlickrDataTranslator alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
            [dataTranslator sortArrayByTitle:_flickrDataArray withCallBack:^(id parseData) {
                _flickrDataArray = [NSArray arrayWithArray:parseData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }];
        });
    }
}

- (IBAction)sortByAuthor:(id)sender {
    
    if ([self isDataExistsToSort]) {
      
        TestFlickrDataTranslator *dataTranslator = [[TestFlickrDataTranslator alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
            [dataTranslator sortArrayByAuthor:_flickrDataArray withCallBack:^(id parseData) {
                _flickrDataArray = [NSArray arrayWithArray:parseData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }];
        });
    }
}

-(BOOL)isDataExistsToSort {
    
    if ([_flickrDataArray count] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No data To sort" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

#pragma mark - SearchBarDelegate

//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    [self.searchResults removeAllObjects];
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
//    
//    _searchResults = [NSMutableArray arrayWithArray: [_flickrDataArray filteredArrayUsingPredicate:resultPredicate]];
//    
//    
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    
//    return NO;
//}

@end
