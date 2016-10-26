//
//  DDBaseWebViewController.h
//  DDBrickDemo
//
//  Created by amoblin on 16/8/9.
//  Copyright © 2016年 marboo. All rights reserved.
//

#import <DDUIKit/DDBaseViewController.h>
#import "DDBaseWebView.h"
#import "Masonry.h"

@interface DDBaseWebViewController : DDBaseViewController

@property (nonatomic, copy) void (^finishClickShareButton)(void);
@property (nonatomic, strong) DDBaseWebView *webView;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, strong) NSData *postBody;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *whiteListUrl; // 需要白名单判断的url
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSString *shareFromKey; // 分享来源的key，用来辨别是什么页面的
// 点击back的时候各controller需要做个性化处理时使用此callback
@property(nonatomic,copy)void (^dismissNotice)(void);

@property (nonatomic, strong) NSString *navTitle; // 自定义title ,如果为空，则使用web给的标题

/**
 *  @brief 是否隐藏关闭按钮
 *  @discussion 如果设置为YES,则web中无论如果都没有关闭按钮，如果设置为NO,则web会在进入深层逻辑之后，点击返回出现关闭按钮,默认为NO
 *  @warning 菜单里面：1.我的钱包 设置里面：1.乘客指南2.专车计价规则 3.专车开具发票 4.专车使用条款 都不显示关闭按钮
 */
@property (nonatomic, assign) BOOL isHideCloseButton;
/**
 *  @brief 读取状态设置
 */
@property (nonatomic, assign) BOOL isHiddenHUD;      //是否开启HUD显示，默认不显示，显示progressbar

/**
 *  应该使用 ProgressBarStyle 方式
 *
 *  @return YES，使用 ProgressBarStyle 方式；NO，使用 HUD 的方式。
 */
- (BOOL)shouldUseProgressBarStyle;

/**
 *  是否隐藏WebView加载进度条
 *
 *  @shouldProgressBarHidden 为 YES:隐藏；NO:不隐藏。默认为NO。
 */
@property (nonatomic,assign) BOOL shouldProgressBarHidden;

//#warning 实现WebView需要注意
// 子类需要实现， 默认为NO 即基础参数加上手机号和token 如果该页面不需要token和手机号，则将该类型实现并设置成YES
@property (nonatomic, assign) BOOL isRemoveTokenAndPhone;

// 是否移除扩展参数，默认为 NO，即默认会使用扩展参数。
// 添加扩展参数会导致 Web 的内置缓存机制失效（由于 URL 中的参数值变化）
// 因此如果 Web 页需要缓存，则需要**移除**默认参数，所需参数通过 JSBridge 接口获取
@property (nonatomic, assign) BOOL isRemoveExtendParams;


// 设置渠道号
+ (void)setChannelNo:(NSString *)channel;
//获取渠道号
+ (NSString *)channelNo;

//设置是否全局启用侧滑手势
+ (void)setShouldSwipeRightBackEnabled:(BOOL)shouldEnabled;

//单独设置该TRBaseWebViewController是否启用侧滑
- (void)setSwipeBackEnabled:(BOOL)enabled;

- (id)initWithUrl:(NSString *)url;

// url
- (NSString *)baseUrl;
// 带上了各项app数据和信息的完整url
- (NSString *)totalUrl;

// 带给webView的额外的参数
// 子类需要实现
- (NSString *)additionalUrl;

//给url添加 sig
- (NSString*)sigAddedUrlWithUrlStr:(NSString*)urlStr;

- (void)loadRequest;

//返回按钮的时间，子类实现
- (void)backEvent:(id)sender;

//把这个方法开放出来，子类可以直接调用。by RobotJi 2015-02-10
- (void)closeButtonClick:(id)sender;

//更多按钮事件方法放出，子类直接重写调用。 by mengxf 2015-10-20
- (void)moreButtonClick:(id)backBtn;

// 子类需要更多的个性化处理时使用，覆写下列方法
// 子类处理UIWebViewDelegate的方法
- (BOOL)trWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)trWebViewDidStartLoad:(UIWebView *)webView;
- (void)trWebViewDidFinishLoad:(UIWebView *)webView;
- (void)trWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

//点击goback按钮时子类可能需要知道这个事件 add by RobotJi 2015-03-02
- (void)trWebViewWillGoBack:(UIWebView *)webView;

//游戏界面，topNav隐藏，浮窗点击退出 by liuzhuan
- (void)backEvent;

- (void)showHUD;
- (void)hideHUD;

- (void)progressViewStart;
- (void)progressViewEnd;

@end
