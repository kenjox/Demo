//
//  Album.h
//  Baboon
//
//  Created by Kennedy Otis on 2014-05-28.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *coverUrl;
@property (nonatomic,copy) NSDictionary *tracks;

-(instancetype) initWithTitle:(NSString *)title cover:(NSString *)coverUrl tracks:(NSDictionary *)tracks;

@end

