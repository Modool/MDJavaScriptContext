//
//  MDJSDocument.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSDocument <MDJSImport>

// 返回文档的绝对基础 URI
@property (nonatomic, copy, readonly) NSString *baseURI;

// 返回文档的body元素
@property (nonatomic, copy, readonly) JSValue *body;

// 返回与文档相关的文档类型声明 (DTD)。
@property (nonatomic, copy, readonly) NSString *doctype;

// 返回用于通过浏览器渲染文档的模式
@property (nonatomic, assign, readonly) NSUInteger documentMode;

// 设置或返回文档的位置
@property (nonatomic, copy, readonly) NSString *documentURI;

// 返回当前文档的域名。
@property (nonatomic, copy, readonly) NSString *domain;

// 返回normalizeDocument()被调用时所使用的配置
@property (nonatomic, copy, readonly) NSString *domConfig;

// 返回文档中所有嵌入的内容（embed）集合
@property (nonatomic, copy, readonly) NSString *embeds;

// 返回对文档中所有 Form 对象引用。
@property (nonatomic, copy, readonly) NSString *forms;

// 返回用于文档的编码方式（在解析时）。
@property (nonatomic, copy, readonly) NSString *inputEncoding;

// 返回文档被最后修改的日期和时间。
@property (nonatomic, copy, readonly) NSString *lastModified;

// 返回文档状态 (载入中……)
@property (nonatomic, copy, readonly) NSString *readyState;

// 返回载入当前文档的文档的 URL。
@property (nonatomic, copy, readonly) NSString *referrer;

// 返回当前文档的标题。
@property (nonatomic, copy, readonly) NSString *title;

// 返回文档完整的URL
@property (nonatomic, copy, readonly) NSString *URL;

// 向文档写 HTML 表达式 或 JavaScript 代码。
- (void)write:(NSString *)string;

// 等同于 write() 方法，不同的是在每个表达式之后写一个换行符。
- (void)writeln:(NSString *)string;

// 删除空文本节点，并连接相邻节点
- (void)normalize;

// 删除空文本节点，并连接相邻节点的
- (void)normalizeDocument;

// 关闭用 document.open() 方法打开的输出流，并显示选定的数据。
- (void)close;

// 打开一个流，以收集来自任何 document.write() 或 document.writeln() 方法的输出。
- (void)open:(NSString *)MIMEtype :(NSString *)replace;

@end
