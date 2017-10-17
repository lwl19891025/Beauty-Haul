//
//  BHXMLParser.m
//  Fleeek
//
//  Created by liuweiliang on 2017/10/2.
//  Copyright © 2017年 fleeek. All rights reserved.
//

#import "BHXMLParser.h"

@interface BHXMLParser()<NSXMLParserDelegate>{
    NSMutableDictionary *currentElement;
}

@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *contents;
@property (copy, nonatomic) void(^completion)(NSArray *);
@end

@implementation BHXMLParser

+ (void)parseContentsOfURL:(NSURL *)url completion:(void(^)(NSArray *))completion{
    BHXMLParser *parser = [[BHXMLParser alloc] initWithContentOfURL:url];
    parser.completion = completion;
    [parser start];
}

- (instancetype)initWithContentOfURL:(NSURL *)url{
    if (self = [super init]) {
        self.contents = [NSMutableArray new];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        self.parser.delegate = self;
    }
    return self;
}

- (void)start{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self.parser parse];
    });
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{

}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completion) {
            self.completion(self.contents);
        }
    });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    if (![[elementName lowercaseString] isEqualToString:@"content"]) {
        currentElement = [NSMutableDictionary dictionary];
        currentElement[@"element"] = elementName;
        currentElement[@"attributes"] = attributeDict;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (currentElement[@"text"]) {
        currentElement[@"text"] = [currentElement[@"text"] stringByAppendingString:string];
    }
    else {
        currentElement[@"text"] = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if (currentElement) {
        [self.contents addObject:currentElement];
        currentElement = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completion) {
            self.completion(nil);
        }
    });
}

@end
