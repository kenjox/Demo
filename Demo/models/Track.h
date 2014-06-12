//
//  Track.h
//  Baboon
//
//  Created by kenjox on 23/02/14.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic,copy) NSString *artist;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;

-(id)initWithTitle:(NSString*)trackTitle andURL:(NSString*)trackURL andArtist:(NSString *)trackArtist;

+(id)trackWithTitle:(NSString *)title andURL:(NSString *)url andArtist:(NSString *)artist;


@end
