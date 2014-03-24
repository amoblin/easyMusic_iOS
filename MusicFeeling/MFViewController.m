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

@interface MFViewController ()

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([segue.identifier isEqualToString:@"quizSegue"]) {
        MFTestViewController *vc = segue.destinationViewController;
        vc.tonesArray = self.tonesArray;
    }
}

@end
