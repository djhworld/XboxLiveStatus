//
//  XBLTagStatusDelegate.h
//  XboxLiveStatus
//
//  Created by Daniel Harper on 21/05/2010.
//  Copyright 2010 AO. All rights reserved.
//

#import "XBLTagStatusCell.h"

@protocol XBLTagStatusDelegate <NSObject>
-(NSImage *)avatarForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident;
-(NSString *)gamerTagForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident;
-(NSString *)statusTextForCell:(XBLTagStatusCell *)cell gamerTagID:(int)ident;
@end