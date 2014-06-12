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
    UIButton *downloadButton;
}

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *albumsWithTracks;



@end

@implementation TracksViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self loadAlbums];
    
}

-(void)setup
{
    _images = [@[] mutableCopy];
    _albumsWithTracks = [@[] mutableCopy];
    
    downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(254, 12, 50, 25)];
    
    [downloadButton setTitle:@"View" forState:UIControlStateNormal];
    [downloadButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[downloadButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[downloadButton layer] setBorderWidth:0.5f];

}
-(void)handleAlbumResponse:(NSDictionary *)response
{
    
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width,320)];
    bgScrollView.delegate = self;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.scrollEnabled = YES;
    bgScrollView.bounces = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    
    _images = [NSMutableArray array];
    
    if (response) {
        
        NSArray *albumArray = response[@"albums"];
        
        _albumsWithTracks = [NSMutableArray array];
        
        
        for (NSDictionary *albumDic in albumArray) {
            
            [_images addObject:albumDic[@"cover"]];
            
            Album *album = [[Album alloc] initWithTitle:albumDic[@"title"] cover:albumDic[@"cover"] tracks:albumDic[@"tracks"]];
            [_albumsWithTracks addObject:album];
            
            NSInteger bgImagesLength = [_images count];
            
            for (int i = 0; i < bgImagesLength; i++ )
            {
                CGRect frame;
                frame.origin.x = bgScrollView.frame.size.width * i;
                frame.origin.y = 0;
                frame.size = bgScrollView.frame.size;
                
                Album *album = _albumsWithTracks[i];
                
                UIImageView *cover = [[UIImageView alloc] initWithFrame:frame];
                cover.contentMode = UIViewContentModeScaleAspectFill;
                
                NSURL *imageUrl = [NSURL URLWithString:album.coverUrl];
                
                if (imageUrl) {
                    
                    [cover setImageWithURL:imageUrl];
                    
                }
                
                [bgScrollView addSubview:cover];
            }
            
            //Content size of the bgScrollview
            bgScrollView.contentSize = CGSizeMake(bgScrollView.frame.size.width * ([albumArray count]),
                                                  bgScrollView.frame.size.height);
            [self.scrollView addSubview:bgScrollView];
            
            //Page control
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 235, bgScrollView.frame.size.width, 10)];
            pageControl.numberOfPages = [albumArray count];
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

#pragma mark - UITableViewDataSourceDelegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = 0;
    if ([_albumsWithTracks count]) {
        NSUInteger currentPage = pageControl.currentPage;
        
        Album *album = (Album *)_albumsWithTracks[currentPage];
        NSArray *tracks = album.tracks;
        
        rows = tracks.count;
    }
    
    return rows;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"trackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger currentPage = pageControl.currentPage;
    
    
    if ([_albumsWithTracks count]) {
        
        
        Album *album = (Album *)_albumsWithTracks[currentPage];
        NSArray *tracks = album.tracks;
        cell.textLabel.text = [tracks[indexPath.row] objectForKey:@"title"];
        NSString *type = [tracks[indexPath.row] objectForKey:@"type"];
        
        
        
        if ([type isEqualToString:@"view"]) {
            [cell addSubview:downloadButton];
        }
        
        
        
    }

    
    return cell;
}


#pragma mark -m UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = bgScrollView.frame.size.width;
    float fractionalPage = bgScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
    [self.tableView reloadData];
    
}

@end
