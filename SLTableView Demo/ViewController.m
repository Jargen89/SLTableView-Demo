//
//  ViewController.m
//  SLTableView Demo
//
//  Created by Rendezvous on 2014-08-16.
//  Copyright (c) 2014 Jason Vieira. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    table = [[SLTableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self.view addSubview:table];
    
    [table loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
    [table loadData];
}
@end
