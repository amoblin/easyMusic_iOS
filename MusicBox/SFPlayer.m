//
//  SFPlayer.m
//  easyMusic
//
//  Created by amoblin on 16/5/9.
//  Copyright © 2016年 amoblin. All rights reserved.
//

#import "SFPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SFPlayer()

@property (nonatomic, assign) AUGraph AUGraph;
@property (nonatomic, assign) AudioUnit samplerUnit;

@end

@implementation SFPlayer

- (instancetype)init;
{
    self = [super init];
    if (self) {
        [self prepareAUGraph];
        [self loadSamplerPath:2];
    }
    return self;
}

- (void)prepareAUGraph;
{
    OSStatus err;

    AUNode samplerNode;
    AUNode remoteOutputNode;

    NewAUGraph(&_AUGraph);
    AUGraphOpen(_AUGraph);

    AudioComponentDescription cd;
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType =  kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = cd.componentFlagsMask = 0;

    err = AUGraphAddNode(_AUGraph, &cd, &remoteOutputNode);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    cd.componentType = kAudioUnitType_MusicDevice;
    cd.componentSubType = kAudioUnitSubType_Sampler;
    err = AUGraphAddNode(_AUGraph, &cd, &samplerNode);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    err = AUGraphConnectNodeInput(_AUGraph, samplerNode, 0, remoteOutputNode, 0);
    if (err) {
        NSLog(@"err = %ld", err);
    }

    err = AUGraphInitialize(_AUGraph);
    if (err) {
        NSLog(@"err = %ld", err);
    }
    err = AUGraphStart(_AUGraph);
    if (err) {
        NSLog(@"err = %ld", err);
    }

    err = AUGraphNodeInfo(_AUGraph,
                          samplerNode,
                          NULL,
                          &_samplerUnit);
    if (err) {
        NSLog(@"err = %ld", err);
    }
}

- (void)noteOn:(NSNumber *)noteNumber velocity:(NSNumber *)velocityNumber;
{
    NSUInteger note = [noteNumber integerValue];
    NSUInteger velocity = [velocityNumber integerValue];
    MusicDeviceMIDIEvent(_samplerUnit,
                         0x90,
                         note,
                         velocity,
                         0);
}


- (void)loadSamplerPath:(int)pathId;
{
    NSArray *resourceArray = @[@"GeneralUser GS SoftSynth v1.44",
                               @"TimGM6mb",
                               @"Drama Piano",
                               @"Electric Grand HQ",
                               @"Electric Piano 1",
                               @"Electric Piano 2",
                               @"Electric Piano 4",
                               @"Electric Piano 5",
                               @"Electric Piano 6",
                               @"Electro Piano 3",
                               @"FLStudioMania.txt",
                               @"FM Piano",
                               @"Fantasy Piano",
                               @"Fazioli Grand Piano",
                               @"Full Grand Piano",
                               @"Giga Piano",
                               @"Grand Piano",
                               @"Kawai Grand Piano",
                               @"Korg Triniton Piano",
                               @"Motif ES6 Concert Piano",
                               @"Piano Bass",
                               @"Reverb Bell Piano",
                               @"SC55 Piano V2",
                               @"Stereo Piano",
                               @"Tight Piano",
                               @"U20 Electric Grand Piano",
                               @"West Coast Piano"];

    NSURL *presetURL;
    presetURL = [[NSBundle mainBundle] URLForResource:resourceArray[4]
                                        withExtension:@"sf2"];
    [self loadFromDLSOrSoundFont:presetURL withPatch:0];
}

- (OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber;
{
    OSStatus result = noErr;
    // fill out a bank preset data structure
    AUSamplerBankPresetData bpdata;
    bpdata.bankURL  = (__bridge CFURLRef)bankURL;
    bpdata.bankMSB  = kAUSampler_DefaultMelodicBankMSB;
    bpdata.bankLSB  = kAUSampler_DefaultBankLSB;
    bpdata.presetID = (UInt8)presetNumber;

    // set the kAUSamplerProperty_LoadPresetFromBank property
    result = AudioUnitSetProperty(_samplerUnit,
                                  kAUSamplerProperty_LoadPresetFromBank,
                                  kAudioUnitScope_Global,
                                  0,
                                  &bpdata,
                                  sizeof(bpdata));
    // check for errors
    NSCAssert(result == noErr,
              @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'",
              (int)result,
              (const char *)&result);
    return result;
}

@end