//
//  NimpleContact.h
//  nimple-iOS
//
//  Created by Guido Schmidt on 04.03.14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NimpleContact : NSManagedObject

@property (nonatomic, retain) NSString  * company;
@property (nonatomic, retain) NSString  * email;
@property (nonatomic, retain) NSString  * job;
@property (nonatomic, retain) NSString  * prename;
@property (nonatomic, retain) NSString  * phone;
@property (nonatomic, retain) NSString  * surname;

-(NSString*) toString;
-(void) SetValueForPrename:(NSString*)p_prename Surname:(NSString*)p_surname PhoneNumber:(NSString*)p_phone MailAddress:(NSString*)p_mail JobTitle:(NSString*)p_job Company:(NSString*)p_company;

@end
