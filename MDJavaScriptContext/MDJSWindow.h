//
//  MDJSWindow.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSDocument, MDJSHistory, MDJSLocation, MDJSNavigator, MDJSScreen, MDJSKeyValue;
@protocol MDJSWindow <MDJSImport>

// 设置窗口状态栏的文本。
@property (nonatomic, copy) NSString *status;

// 设置或返回窗口状态栏中的默认文本。
@property (nonatomic, copy) NSString *defaultStatus;

// 设置或返回窗口的名称。
@property (nonatomic, copy) NSString *name;

// 原链接
@property (nonatomic, copy, readonly) NSString *origin;

// 返回窗口是否已被关闭。
@property (nonatomic, assign, readonly) BOOL closed;

// 对 Document 对象的只读引用。(请参阅对象)
@property (nonatomic, strong, readonly) JSValue<MDJSDocument> *document;

// 对 History 对象的只读引用。请参数 History 对象。
@property (nonatomic, strong, readonly) JSValue<MDJSHistory> *history;

// 用于窗口或框架的 Location 对象。请参阅 Location 对象。
@property (nonatomic, strong, readonly) JSValue<MDJSLocation> *location;

// 对 Navigator 对象的只读引用。请参数 Navigator 对象。
@property (nonatomic, strong, readonly) JSValue<MDJSNavigator> *navigator;

// 返回对创建此窗口的窗口的引用。
@property (nonatomic, strong, readonly) JSValue<MDJSWindow> *opener;

// 返回父窗口。
@property (nonatomic, strong, readonly) JSValue<MDJSWindow> *parent;

// 返回最顶层的父窗口。
@property (nonatomic, strong, readonly) JSValue<MDJSWindow> *top;

// 对 Screen 对象的只读引用。请参数 Screen 对象。
@property (nonatomic, strong, readonly) JSValue<MDJSScreen> *screen;

// 在浏览器中存储 key/value 对。没有过期时间。
@property (nonatomic, strong, readonly) JSValue<MDJSKeyValue> *localStorage;

// 在浏览器中存储 key/value 对。 在关闭窗口或标签页之后将会删除这些数据。
@property (nonatomic, strong, readonly) JSValue<MDJSKeyValue> *sessionStorage;

// 返回窗口中所有命名的框架。该集合是 Window 对象的数组，每个 Window 对象在窗口中含有一个框架。
@property (nonatomic, strong, readonly) JSValue<MDJSWindow> *frames;

// 设置或返回窗口中的框架数量。
@property (nonatomic, assign, readonly) NSUInteger length;

// 返回相对于屏幕窗口的x坐标
@property (nonatomic, assign, readonly) CGFloat screenLeft;

// 返回相对于屏幕窗口的y坐标
@property (nonatomic, assign, readonly) CGFloat screenTop;

// 返回相对于屏幕窗口的x坐标
@property (nonatomic, assign, readonly) CGFloat screenX;

// 返回相对于屏幕窗口的y坐标
@property (nonatomic, assign, readonly) CGFloat screenY;

// 返回窗口的文档显示区的高度。
@property (nonatomic, assign, readonly) CGFloat innerHeight;

// 返回窗口的文档显示区的宽度。
@property (nonatomic, assign, readonly) CGFloat innerWidth;

// 返回窗口的外部高度，包含工具条与滚动条。
@property (nonatomic, assign, readonly) CGFloat outerHeight;

// 返回窗口的外部宽度，包含工具条与滚动条。
@property (nonatomic, assign, readonly) CGFloat outerWidth;

// 设置或返回当前页面相对于窗口显示区左上角的 X 位置。
@property (nonatomic, assign) CGFloat pageXOffset;

// 设置或返回当前页面相对于窗口显示区左上角的 Y 位置。
@property (nonatomic, assign) CGFloat pageYOffset;

// 显示带有一段消息和一个确认按钮的警告框。
- (void)alert:(NSString *)message;

// 把键盘焦点从顶层窗口移开。
- (void)blur;

// 取消由 setInterval() 设置的 timeout。
- (void)clearInterval:(id)timerID;

// 取消由 setTimeout() 方法设置的 timeout。
- (void)clearTimeout:(id)timerID;

// 关闭浏览器窗口。
- (void)close;

// 显示带有一段消息以及确认按钮和取消按钮的对话框。
- (BOOL)confirm:(NSString *)message;

// 创建一个 pop-up 窗口。
- (id)createPopup;

// 把键盘焦点给予一个窗口。
- (void)focus;

// 可相对窗口的当前坐标把它移动指定的像素。
- (void)moveBy:(CGFloat)x :(CGFloat)y;

// 把窗口的左上角移动到一个指定的坐标。
- (void)moveTo:(CGFloat)x :(CGFloat)y;

// 打开一个新的浏览器窗口或查找一个已命名的窗口。
- (void)open:(NSString *)URL :(NSString *)name :(NSString *)specs :(NSString *)replace;

// 打印当前窗口的内容。
- (void)print;

// 显示可提示用户输入的对话框。
- (NSString *)prompt;

// 按照指定的像素调整窗口的大小。
- (void)resizeBy:(CGFloat)width :(CGFloat)height;

// 把窗口的大小调整到指定的宽度和高度。
- (void)resizeTo:(CGFloat)width :(CGFloat)height;

// 按照指定的像素值来滚动内容。
- (void)scrollBy:(CGFloat)xnum :(CGFloat)ynum;

// 把内容滚动到指定的坐标。
- (void)scrollTo:(CGFloat)xpos :(CGFloat)ypos;

// 按照指定的周期（以毫秒计）来调用函数或计算表达式。
- (id)setInterval:(NSString *)function :(NSTimeInterval)milliseconds;

// 在指定的毫秒数后调用函数或计算表达式。
- (id)setTimeout:(NSString *)function :(NSTimeInterval)milliseconds;

@end
