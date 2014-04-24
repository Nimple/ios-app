//
//  Logging.h
//  nimple-iOS
//
//  Created by Ben John on 24/04/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mixpanel.h"
#import "NimpleContact.h"

@interface Logging : NSObject

+ (void)initMixpanel;
+ (void)sendApplicationStartedEvent;
+ (void)sendContactAddedEvent:(NimpleContact*)nimpleContact;
+ (void)sendContactTransferredEvent ;
+ (void)sendNimpleCodeChangedEvent:(NSDictionary*)ownNimpleCode;
+ (NSString*) checkForEmptyStringAndFormatOutput:(NSString*)needle;

@end
