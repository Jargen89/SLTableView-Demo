//
//  SLTableView.h
//  test
//
//  Created by Rendezvous on 2014-08-16.
//  Copyright (c) 2014 Jason Vieira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface SLTableView : UITableView <UITableViewDataSource,UITableViewDelegate,CustomIOS7AlertViewDelegate>
{
    NSMutableArray *content;
    NSMutableData *responseData;
}

-(void) loadData;
@end
