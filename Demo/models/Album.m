//
//  Album.m
//  Baboon
//
//  Created by Kennedy Otis on 2014-05-28.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import "Album.h"

@implementation Album

-(instancetype) initWithTitle:(NSString *)title cover:(NSString *)coverUrl tracks:(NSArray *)tracks
{
    self = [super init];
    
    if (self) {
        
        _title = title;
        _coverUrl = coverUrl;
        _tracks = tracks;
    }
    
    return self;
}

@end