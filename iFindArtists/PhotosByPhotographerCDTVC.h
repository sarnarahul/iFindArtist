
//

#import "CoreDataTableViewController.h"
#import "Photographer.h"
#import "CustomTableViewCell.h"

@interface PhotosByPhotographerCDTVC : CoreDataTableViewController<UIActionSheetDelegate>

// The Model for this class.
// It displays all the Photo objects taken by this Photographer
//   (i.e. all Photo objects whose "whoTook" is this Photographer).
@property (nonatomic, strong) Photographer *photographer;

@end
