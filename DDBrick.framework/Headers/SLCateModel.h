//
//  SLCateModel.h
//  iMarboo
//
//  Created by amoblin on 15/12/1.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <DDUIKit/DDBaseModel.h>

typedef NS_ENUM(NSInteger, SLCateType) {
    SLCateTypeText,
    SLCateTypeSelect,
    SLCateTypeDate,
    SLCateTypePicker,
    SLCateTypeSwitch,
    SLCateTypeAppStore,
    SLCateTypeTitleAndSubtitle,
    SLCateTypeHourMinutePicker,
};

@protocol SLCateModel <NSObject>
@end

@interface SLCateModel : DDBaseModel

@property (nonatomic, strong) NSString              *name;
@property (nonatomic, strong) NSString<Optional>    *placeholder;

@property (nonatomic, strong) NSString<Optional>    *value; // string or dictionary

@property (nonatomic, strong) NSString<Optional>    *identity; // id

@property (nonatomic, strong) NSString<Optional>    *action; // press item action

@property (nonatomic, strong) NSString              *url;

@property (nonatomic, strong) NSObject              *model;

@property (nonatomic, strong) NSDictionary<Ignore>  *valuePathDict;

@property (nonatomic, strong) NSDictionary<Ignore>  *layoutDict;

@property (nonatomic, strong) NSString<Optional>    *title;

@property (nonatomic, assign) BOOL                  editable;

@property (nonatomic, strong) NSArray<Optional>     *collections;
@property (nonatomic, strong) NSString              *valuePath;
@property (nonatomic, strong) NSString              *layout;
@property (nonatomic, strong) NSDictionary          *contentMapping;

@property (nonatomic, assign) SLCateType            type;

- (instancetype)initWithType:(SLCateType)type;
- (instancetype)initWithName:(NSString *)name type:(SLCateType)type;

@property (nonatomic, copy) void (^pressAction)(id data);

@property (nonatomic, copy) void (^updateValueBlock)();

@end
