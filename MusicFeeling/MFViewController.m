//
//  MFViewController.m
//  MusicFeeling
//
//  Created by amoblin on 14-3-15.
//  Copyright (c) 2014年 amoblin. All rights reserved.
//

#import "MFViewController.h"
#import "MFCollectionViewCell.h"
#import "MFTestViewController.h"

#import "IDZTrace.h"
#import "IDZOggVorbisFileDecoder.h"

@interface MFViewController ()

@property (nonatomic, strong) NSMutableArray *playerCache;
@property (nonatomic, strong) NSMutableArray *tonesArray;
@property (nonatomic) NSIndexPath *currentIndexPath;
@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)tonesArray {
    if (_tonesArray == nil) {
        _tonesArray = [[NSMutableArray alloc] initWithCapacity:9];
        for (NSInteger i=0; i<9; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:20];
            [_tonesArray addObject:array];
        }
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        NSError * error;
        NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
        for (NSString *file in directoryContents) {
            if ( ! [file.pathExtension isEqualToString:@"ogg"]) {
                continue;
            }
            NSInteger number = [[file substringWithRange:NSMakeRange(1, 1)] integerValue];
            [_tonesArray[number] addObject:file];
        }
    }
    return _tonesArray;
}

- (IBAction)play:(id)sender {
    NSString *name = [self.tonesArray[self.currentIndexPath.section][self.currentIndexPath.item] stringByDeletingPathExtension];
    [self playTone:name];
}

- (void)playTone:(NSString *)name {
    IDZTrace();

    NSError *error;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@".ogg"];
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);

    BOOL flag = NO;
    for (IDZAQAudioPlayer *player in self.playerCache) {
        if ( ! player.isPlaying) {
            flag = YES;
            IDZAQAudioPlayer *newPlayer = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
            [self.playerCache replaceObjectAtIndex:[self.playerCache indexOfObject:player] withObject:newPlayer];
            newPlayer.delegate = self;
            [newPlayer prepareToPlay];

            //[self startTimer];
            [newPlayer play];
            break;
        }
    }
    if (flag == NO) {
        IDZAQAudioPlayer *player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
        player.delegate = self;
        [player prepareToPlay];

        //[self startTimer];
        [player play];
        [self.playerCache addObject:player];
    }
}

- (NSMutableArray *)playerCache {
    if (_playerCache == nil) {
        _playerCache = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _playerCache;
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
    cell.titleLabel.text = [self.tonesArray[indexPath.section][indexPath.item] stringByDeletingPathExtension];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tonesArray[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.tonesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self play:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MFTestViewController *vc = segue.destinationViewController;
    vc.tonesArray = self.tonesArray;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray *)keyCommands {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:26];
    NSArray *keys = @[@"c", @"d", @"e", @"f", @"g", @"a", @"b"];
    for (NSString *key in keys) {
        UIKeyCommand *keyCommand = [UIKeyCommand keyCommandWithInput:key modifierFlags:kNilOptions action:@selector(keyPressed:)];
        [array addObject:keyCommand];
    }
    return array;
}

- (void)keyPressed:(UIKeyCommand *)keyCommand {
    NSLog(@"%@", keyCommand.input);
    NSString *toneName = [NSString stringWithFormat:@"%@%@", keyCommand.input, [NSNumber numberWithInteger:4]];

    [self playTone:toneName];
}
@end
