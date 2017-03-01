//
//  FFFPOnePickerAcrionSheet.h
//  PersonaInformationDemo
//
//  Created by He Wei on 6/5/16.
//  Copyright © 2016 Winn.He. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol PASQRCodeActionSheetDelegate;

@interface PASQRCodeActionSheet : UIView 

//@property (nonatomic, weak) id<PASQRCodeActionSheetDelegate> delegate;

- (id)initWithDownloadURLString:(NSString *)downloadString;
- (void)show;

@end

//@protocol PASQRCodeActionSheetDelegate <NSObject>
//
//
//
//@end
