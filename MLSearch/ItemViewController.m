//
//  ItemViewController.m
//  MLSearch
//
//  Created by Julian Centurion on 5/13/15.
//  Copyright (c) 2015 Julian Centurion. All rights reserved.
//

#import "ItemViewController.h"
#import "Article.h"

@interface ItemViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.navigationController b
    self.responseData = [NSMutableData data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) ShowItem:(NSString *) itemID{
    NSString * baseURL = @"https://api.mercadolibre.com/items/";
    
    NSString *URLtoUSE = [baseURL stringByAppendingString:itemID];
    
    NSLog(@"%@", URLtoUSE);
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLtoUSE]];
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Article"
                                                    message:@"The Internet connection appears to be offline"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    /*NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    NSString* responseString = [[NSString alloc] initWithData:self.responseData
                                                     encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseString);
    */
    NSError *myError = nil;
    

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    if (myError != nil){
        NSString *errorString = [myError description];
        NSLog(@"Parse error: %@", errorString);
    } else{
        Article *article = [Article new];
        article.title = [result objectForKey:@"title"];
        article.price = [result objectForKey:@"price"];
        article.URLImage = [result objectForKey:@"thumbnail"];
        article.id = [result objectForKey:@"id"];
        //self.navigationItem.title = article.title;
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@",article.title];//article.title;
        self.priceLabel.text = [NSString stringWithFormat:@"%@",article.price];//article.price;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:article.URLImage]];
        self.imagenViewSpace.image = [UIImage imageWithData:imageData];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
