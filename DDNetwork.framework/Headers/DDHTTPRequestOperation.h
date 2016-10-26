//
//  DDHTTPRequestOperation.h
//  iMarboo
//
//  Created by amoblin on 15/12/21.
//  Copyright © 2015年 amoblin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPRequestOperation.h"

typedef void (^AFBlock)(AFHTTPRequestOperation *, id);

@interface DDHTTPRequestOperation : AFHTTPRequestOperation

@end
