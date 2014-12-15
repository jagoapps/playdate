//
//  PDHelper.m
//  PlayDate
//
//  Created by Vakul on 01/05/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "PDHelper.h"
#import <AddressBook/AddressBook.h>
#import "ContactsData.h"
@interface PDHelper() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PDImagePickerBlock imagePickerBlock;


@end


@implementation PDHelper

static PDHelper *helper = nil;
+(PDHelper *)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PDHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - BOOL
-(BOOL)isInternetAvailable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *) &zeroAddress);
    
    if(reachability != NULL)
    {
        // NetworkStatus retVal = NotReachable
        SCNetworkReachabilityFlags flags;
        
        if(SCNetworkReachabilityGetFlags(reachability, &flags))
        {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                // then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

-(BOOL)isIOS7
{
    return ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0);
}

-(BOOL)isIPhone5
{
    return ([[UIScreen mainScreen] applicationFrame].size.height > 480.0);
}

-(BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

-(BOOL)isPhotoGalleryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark - Email Validation
-(BOOL)validateEmail:(NSString *)inputText
{
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText]) {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        NSUInteger indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    if ([inputText length]==0) {
        return   TRUE;
    }
    return FALSE;
}


#pragma mark - ScreenShot from View
-(UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return saveImage;
}

#pragma mark - Application Color
-(UIColor *)applicationBackgroundColor
{
    return COLOR_FROM_RGB (227.0, 227.0, 227.0, 1.0);
}

-(UIColor *)applicationThemeBlueColor
{
    return COLOR_FROM_RGB(0.0, 151.0, 220.0, 1.0);
}

-(UIColor *)applicationThemeGreenColor
{
    return COLOR_FROM_RGB(127.0, 206.0, 49.0, 1.0);
}

#pragma mark - Application Font
-(UIFont *)applicationFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gill Sans" size:size];
}


static NSDateFormatter *backEndDateFormatter = nil;
-(NSDateFormatter *)backEndDateFormatter
{
    if (backEndDateFormatter == nil) {
        backEndDateFormatter = [[NSDateFormatter alloc] init];
        [backEndDateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    
    return backEndDateFormatter;
}


#pragma mark - Perfect Size Of Image
-(CGSize)perfectSizeOfImage:(UIImage *)image withMaximumHeight:(CGFloat)maxHeight andMaximumWidth:(CGFloat)maxWidth
{
    CGFloat height = 0.0;
    CGFloat width = 0.0;
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    
    
    if(imageHeight <= maxHeight)
    {
        height = imageHeight;
        if(imageWidth <= maxWidth)
        {
            width = image.size.width;
        }
        else
        {
            width = maxWidth;
            height = (imageHeight/imageWidth) * width;
        }
    }
    else
    {
        height = maxHeight;
        width = (imageWidth/imageHeight) * height;
        
        if(width > maxWidth)
        {
            width = maxWidth;
            height = (imageHeight/imageWidth) * width;
        }
    }
    
    CGSize perfectSize = CGSizeMake(width, height);
    
    return perfectSize;
}


#pragma mark - Gallery
-(void)openGalleryFromController:(UIViewController *)controller withCompletionBlock:(PDImagePickerBlock)block
{
    if ([self isPhotoGalleryAvailable])
    {
        self.imagePickerBlock = block;
        
        UIImagePickerController  *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [controller presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Photo Gellery is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
    }
}

-(void)openCameraFromController:(UIViewController *)controller withCompletionBlock:(PDImagePickerBlock)block
{
    if ([self isCameraAvailable])
    {
        self.imagePickerBlock = block;
        
        UIImagePickerController  *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [controller presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Photo Gellery is not available in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
    }

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.imagePickerBlock)
    {
        self.imagePickerBlock (nil);
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.imagePickerBlock)
    {
        self.imagePickerBlock ([info objectForKey:UIImagePickerControllerOriginalImage]);
    }
}

#pragma mark - Add Recents

-(void)addRecent:(NSMutableArray *)array
{
    array = [[NSMutableArray alloc] init];
}
-(void)getAllContacts:(PDContactBlock)arrContact;
{
    
    CFErrorRef *error = nil;
    
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
#ifdef DEBUG
        NSLog(@"Fetching contact info ----> ");
#endif
        
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
        
        
        for (int i = 0; i < nPeople; i++)
        {
            ContactsData *contacts = [ContactsData new];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name and Last Name
            
            

            contacts.firstNames =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            contacts.lastNames =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            if (!contacts.firstNames) {
                contacts.firstNames = @"";
            }
            if (!contacts.lastNames) {
                contacts.lastNames = @"";
            }
            
            // get contacts picture, if pic doesn't exists, show standart one
            
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
            contacts.image = [UIImage imageWithData:imgData];
            if (!contacts.image) {
                contacts.image = [UIImage imageNamed:@"NOIMG.png"];
            }
            //get Phone Numbers
            
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                
                //NSLog(@"All numbers %@", phoneNumbers);
                
            }
            
            
            [contacts setNumbers:phoneNumbers];
            
            //get Contact email
            
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                
                [contactEmails addObject:contactEmail];
                // NSLog(@"All emails are:%@", contactEmails);
                
            }
            
            [contacts setEmails:contactEmails];
             contacts.hasFriend=0;
            
            
            [items addObject:contacts];
            
#ifdef DEBUG
            //NSLog(@"Person is: %@", contacts.firstNames);
            //NSLog(@"Phones are: %@", contacts.numbers);
            //NSLog(@"Email is:%@", contacts.emails);
#endif
            
            
            
            
        }
        
        NSLog(@"%@",items);
        arrContact(items);

            //  return items;
        
        
        
    } else {
#ifdef DEBUG
        NSLog(@"Cannot fetch Contacts :( ");        
#endif

      arrContact(nil);
        //return NO;
        
        
    }
    
}
@end


