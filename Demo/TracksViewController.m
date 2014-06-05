//
//  TracksViewController.m
//  Baboon
//
//  Created by Kennedy Otis on 2014-06-03.
//  Copyright (c) 2014 winternet. All rights reserved.
//

#import "TracksViewController.h"
#import "Track.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface TracksViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *bgScrollView;
    UIPageControl *pageControl;
    NSMutableArray *images;
    NSMutableArray *albumsWithTracks;
}



@end

@implementation TracksViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAlbums];
    
}
-(void)handleAlbumResponse:(NSDictionary *)response
{
    
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width,130)];
    bgScrollView.delegate = self;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.scrollEnabled = YES;
    bgScrollView.bounces = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    
    images = [NSMutableArray array];
    
    if (response) {
        
        NSArray *albumArray = response[@"albums"];
        
        albumsWithTracks = [NSMutableArray array];
        
        
        for (NSDictionary *albumDic in albumArray) {
            
            [images addObject:albumDic[@"cover"]];
            
            Album *album = [[Album alloc] initWithTitle:albumDic[@"title"] cover:albumDic[@"cover"] tracks:albumDic[@"tracks"]];
            [albumsWithTracks addObject:album];
            
            NSInteger bgImagesLength = [images count];
            
            for (int i = 0; i < bgImagesLength; i++ )
            {
                CGRect frame;
                frame.origin.x = bgScrollView.frame.size.width * i;
                frame.origin.y = 0;
                frame.size = bgScrollView.frame.size;
                
                Album *album = albumsWithTracks[i];
                
                UIImageView *cover = [[UIImageView alloc] initWithFrame:frame];
                cover.contentMode = UIViewContentModeScaleAspectFill;
                cover.alpha = 0.8;
                
                UILabel *coverTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 54, 280, 25)];
                coverTitle.text = album.title;
                coverTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
                coverTitle.textAlignment = NSTextAlignmentCenter;
                coverTitle.textColor = [UIColor whiteColor];
                [cover addSubview:coverTitle];
                
                
                NSURL *imageUrl = [NSURL URLWithString:album.coverUrl];
                
                if (imageUrl) {
                    
                    [cover setImageWithURL:imageUrl];
                    
                }
                
                [bgScrollView addSubview:cover];
            }
            
            //Content size of the bgScrollview
            bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width * ([images count]),
                                                  bgScrollView.frame.size.height);
            [self.scrollView addSubview:bgScrollView];
            
            //Page control
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 110, bgScrollView.frame.size.width, 10)];
            pageControl.numberOfPages = [images count];
            pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            
            [self.scrollView addSubview:pageControl];
            
            
        }
        
        
        
    }
}

-(void)loadAlbums
{
    
    [[AFHTTPSessionManager manager] GET:@"http://www.annalenawinter.se/app3/albums"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self handleAlbumResponse:responseObject];
                                        
                                    });
                                    
                                    
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                }];
    
}

#pragma mark -m UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = bgScrollView.frame.size.width;
    float fractionalPage = bgScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"Finised page one");
    CGFloat pageWidth = bgScrollView.frame.size.width;
    float fractionalPage = bgScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
    Album *album =  albumsWithTracks[page];
    
    NSLog(@"Tracks in that album %@ are %@",album.title,album.tracks);
    
    decelerate = NO;
}





#pragma mark - UITableViewDataSourceDelegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"trackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}



@end
