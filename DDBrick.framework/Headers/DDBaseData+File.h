//
//  DDBaseData+File.h
//  Pods
//
//  Created by amoblin on 16/5/27.
//
//

#import "DDBaseData.h"
@class DDBaseData;

@interface DDBaseData (File)

- (instancetype)initWithPath:(NSString *)path;

- (NSArray *)subFileArrayWithDataClass:(Class)dataClass;
@end
