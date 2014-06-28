//
//  KHCSlideTableViewCell.m
//  slider
//
//  Created by Chuck Lin on 6/28/14.
//
//

#import "KHCSlideTableViewCell.h"

@implementation KHCSlideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;

        // Initialize UI units
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, size.height, size.height)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.height+4, 0, size.width - size.height, size.height - 16.0)];
        self.pageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.height+4, size.height - 16.0, size.width - size.height, 16)];
        
        // Configure Main Label
        [self.coverImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [self.titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.pageNumLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.pageNumLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        // Add Main Label to Content View
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.pageNumLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
