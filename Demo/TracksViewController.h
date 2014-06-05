//
//  TracksViewController.h
//  Baboon
//
//  Created by Kennedy Otis on 2014-06-03.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface TracksViewController : UIViewController

@property (nonatomic) NSMutableArray *albums;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIView *scrollView;

@end

