//
//  SLTableView.m
//  test
//
//  Created by Rendezvous on 2014-08-16.
//  Copyright (c) 2014 Jason Vieira. All rights reserved.
//

#import "SLTableView.h"
#import "RedditPost.h"
#import "AFHTTPRequestOperation.h"

@implementation SLTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        [self loadData];
        [self registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        NSLog(@"HELLOO");
    }
    return self;
}
-(id) init{
    self = [super init];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        [self loadData];
        [self registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        NSLog(@"HELLOOO");
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [content count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        //changes
        
    }
    // Configure the cell...
    RedditPost *post = [content objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.text = [post title];
    dispatch_queue_t downloadQueue = dispatch_queue_create("imgDownload", nil);
    dispatch_async(downloadQueue, ^{
        NSURL *imgURL = [NSURL URLWithString:post.thumbnailUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[cell imageView] setImage:[UIImage imageWithData:imgData]];
            [cell setNeedsLayout];
        });
        
    });
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self beginUpdates];
    //[self endUpdates];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    RedditPost *post = [content objectAtIndex:indexPath.row];
    __block UIImageView *imageView;
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("imgDownload", nil);
    dispatch_async(downloadQueue, ^{
        NSURL *imgURL = [NSURL URLWithString:post.url];
        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            //app will crash if the url does not point to an image
            UIImage *image = [UIImage imageWithData:imgData];
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, image.size.height * (self.frame.size.width - 20)/image.size.width)];
            [imageView setImage:image];
            CustomIOS7AlertView *popUp = [[CustomIOS7AlertView alloc] init];
            [popUp setContainerView:imageView];
            [popUp setButtonTitles:[NSMutableArray arrayWithObjects:@"close window", nil]];
            [popUp setDelegate:self];
            [popUp show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
    });
    
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rect = [[[content objectAtIndex:indexPath.row] title] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15.0]} context:nil];
    CGFloat value = 44 + rect.size.height;
    //if (indexPath.row == [tableView indexPathForSelectedRow].row) {
    //    value += 100;
    //}
    return value;
}
- (void)loadData {
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];

    NSURL *json = [[NSURL alloc] initWithString:@"http://www.reddit.com/r/pics.json"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:json];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request ];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        content = [[NSMutableArray alloc] init];
        //NSLog(@"JSON DATA: %@",responseObject);
        NSArray *posts = [NSArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"children"] ];
        
        for (NSDictionary *dic in posts) {
            RedditPost *post = [[RedditPost alloc] init];

            [post setTitle:[[dic objectForKey:@"data"] objectForKey:@"title"]];
            [post setUrl:[[dic objectForKey:@"data"] objectForKey:@"url"]];
            [post setThumbnailUrl:[[dic objectForKey:@"data"] objectForKey:@"thumbnail"]];
            [content addObject:post];
        }
        
        [self reloadData];
        
    } failure:^(AFHTTPRequestOperation *oepration, NSError *error) {
        NSLog(@"NSError: %@", error.localizedDescription);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [alertView close];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
