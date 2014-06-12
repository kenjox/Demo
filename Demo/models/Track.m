//
//  Track.m
//  Baboon
//
//  Created by kenjox on 23/02/14.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import "Track.h"

@implementation Track

@synthesize title;
@synthesize url;
@synthesize artist;

-(id)initWithTitle:(NSString*)trackTitle andURL:(NSString*)trackURL andArtist:(NSString *)trackArtist
{
    self = [super init];
    
    if (self)
    {
        title  = trackTitle;
        url    = trackURL;
        artist = trackArtist;
    }
    
    return self;
}

+(id)trackWithTitle:(NSString *)title andURL:(NSString *)url andArtist:(NSString *)artist
{
    return [[self alloc] initWithTitle:title andURL:url andArtist:artist];
}

@end
