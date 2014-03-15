//
//  MFViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFViewController.h"
#import "MFCollectionViewCell.h"

#import "IDZTrace.h"
#import "IDZOggVorbisFileDecoder.h"

@interface MFViewController ()

@property (nonatomic, strong) id<IDZAudioPlayer> player;
@property (nonatomic, strong) NSMutableArray *tonesArray;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)tonesArray {
    if (_tonesArray == nil) {
        _tonesArray = [[NSMutableArray alloc] initWithCapacity:500];
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        NSError * error;
        NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
        for (NSString *file in directoryContents) {
            if ([file.pathExtension isEqualToString:@"ogg"]) {
                [_tonesArray addObject:file];
            }
        }
    }
    return _tonesArray;
}

- (IBAction)play:(id)sender {
    IDZTrace();
    NSError *error;
    NSString *name = [self.tonesArray[self.currentIndex] stringByDeletingPathExtension];
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
    self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];

    //[self startTimer];
    [self.player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IDZAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(id<IDZAudioPlayer>)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
    //[self stopTimer];
    //[self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(id<IDZAudioPlayer>)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    //[self stopTimer];
    //[self updateDisplay];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    MFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.titleLabel.text = [self.tonesArray[indexPath.item] stringByDeletingPathExtension];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tonesArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
    [self play:nil];
}
@end
