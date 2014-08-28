//
//  Base64Transcoder.h
//  Kimster
//
//  Created by Ankit Thakur on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//   I am very thankful to Matt Gallagher, for providing such a great hint for Base64 encoding and decoding.
//

#import <Foundation/Foundation.h>


@interface Base64Transcoder : NSObject {

}

void *NewBase64Decode(
					  const char *inputBuffer,
					  size_t length,
					  size_t *outputLength);

char *NewBase64Encode(
					  const void *inputBuffer,
					  size_t length,
					  bool separateLines,
					  size_t *outputLength);

- (NSData *)decodedDataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedStringfromData:(NSData *)data;


@end
