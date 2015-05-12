//
//  SearchFildViewController.m
//  MLSearch
//
//  Created by Julian Centurion on 5/11/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import "SearchFildViewController.h"
#import "SearchResultsTableViewController.h"

@interface SearchFildViewController ()
@end

@implementation SearchFildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    
    [self.view addGestureRecognizer:tapGesture];*/
    
    //self.searchHistoryArray = [NSMutableArray new];
    self.searchHistoryArray =  [[[[NSUserDefaults standardUserDefaults] arrayForKey:@"searchHistory"] mutableCopy] init];

    [self.searchTableView reloadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    
    NSLog(@"[self.searchHistoryArray count]: %lu", (unsigned long)[self.searchHistoryArray count]);
    
    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void) ReloadTableData{
    [self.searchTableView reloadData];
}

- (IBAction)ClearButtonClicked:(id)sender {
    self.searchHistoryArray = [NSMutableArray new];
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArray forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)hideKeyBoard {
    [self.searchStringTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) ChangeViewAndSearch{
    if ([self.searchStringTextField.text isEqual: @""]){
        NSLog(@"Empty string");
        return;
    }
    [self SaveInTextSringInHistory];
    SearchResultsTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResult"];
    [self.navigationController pushViewController:viewController animated:YES ];
    [viewController ReceiveSearchString:self.searchStringTextField.text];
}

- (void) SaveInTextSringInHistory{
    //self.searchHistoryArray = [NSMutableArray new];
    NSString *stringToSave = self.searchStringTextField.text;
    [self.searchHistoryArray addObject:stringToSave];
    NSLog(@"string to save: %@", stringToSave);
    
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArray forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)ClickOnSearchButton:(id)sender {
    [self ChangeViewAndSearch];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [self.searchStringTextField becomeFirstResponder];
    [self.searchStringTextField resignFirstResponder];
    [self ChangeViewAndSearch];
}

#pragma Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"[self.searchHistoryArray count]: %lu", (unsigned long)[self.searchHistoryArray count]);
    return [self.searchHistoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"SearchHistorialCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = (self.searchHistoryArray) [indexPath.row];
    //cell.textLabel.text = @"test";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchStringTextField becomeFirstResponder];
    [self.searchStringTextField resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"text label %@", cell.textLabel.text);
    SearchResultsTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResult"];
    [self.navigationController pushViewController:viewController animated:YES ];
    [viewController ReceiveSearchString:cell.textLabel.text];
}


@end
