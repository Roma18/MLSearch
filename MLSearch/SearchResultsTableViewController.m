//
//  SearchResultsTableViewController.m
//  MLSearch
//
//  Created by Julian Centurion on 5/7/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "SearchItem.h"
#import "SearchItemTableViewCell.h"
#import "SearchFildViewController.h"
#import "ItemViewController.h"

@interface SearchResultsTableViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *searchItems;
@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    self.responseData = [NSMutableData data];
    //[self StartSearch:@"Samsung"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) ReceiveSearchString:(NSString *)search{
    NSLog (@"Search string %@", search);
    [self StartSearch:search ];
}

-(void) StartSearch:(NSString *) searchKey{
    NSString * baseURL = @"https://api.mercadolibre.com/sites/MLA/search?q=";
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)searchKey,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    
    NSString *URLtoUSE = [baseURL stringByAppendingString:encodedString];
    
    NSLog(@"%@", URLtoUSE);
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLtoUSE]];
    //[NSURLConnection initWithRequest:request delegate:self];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSString *errorString = [error description];
    NSLog(@"Connection failed: %@", errorString);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                    message:@"The Internet connection appears to be offline"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    /*NSString* responseString = [[NSString alloc] initWithData:self.responseData
                                                     encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseString);*/
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSString *limit = [[res objectForKey:@"paging"] objectForKey:@"paging"];
    int limintInt = [limit intValue];
    
    self.searchItems = [NSMutableArray arrayWithCapacity:(NSInteger) limintInt];
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    if ( [results count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                        message:@"No result were found"
                                                       delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [alert show];
        
    } else {
    
        for (NSDictionary *result in results) {
            SearchItem *searchItem = [SearchItem new];
            searchItem.title = [result objectForKey:@"title"];
            searchItem.price = [result objectForKey:@"price"];
            searchItem.URLImage = [result objectForKey:@"thumbnail"];
            searchItem.id = [result objectForKey:@"id"];
            [self.searchItems addObject:searchItem];
        }
        
    }
    [self reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (void)reloadData{
    NSLog(@"reload data");
    
    NSLog(@"self.searchItems count: %lu",  (unsigned long)[self.searchItems count]);
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItemTableViewCell *cell = (SearchItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchItemCell"];
    
    SearchItem *searchItem = (self.searchItems) [indexPath.row];
    cell.titleLabel.text = searchItem.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",searchItem.price];//searchItem.price;
    [cell.priceLabel sizeToFit];
    cell.articleID = [NSString stringWithFormat:@"%@", searchItem.id];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchItem.URLImage]] ;
    cell.imageViewSpace.image = [UIImage imageWithData:imageData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchItemTableViewCell *cell = (SearchItemTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    SearchItem *searchItem = (self.searchItems) [indexPath.row];
    
    cell.articleID = searchItem.id;
    
    ItemViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemView"];
    [self.navigationController pushViewController:viewController animated:YES ];
    [viewController ShowItem:searchItem.id];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
