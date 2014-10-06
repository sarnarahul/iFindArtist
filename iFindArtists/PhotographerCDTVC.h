

#import "CoreDataTableViewController.h"
#import "CustomTableViewCell.h"

@interface PhotographerCDTVC : CoreDataTableViewController

// The Model for this class.
// Essentially specifies the database to look in to find all Photographers to display in this table.
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
