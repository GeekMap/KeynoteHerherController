//
//  KHCSlideTableViewCell.m
//  slider
//
//  Created by Chuck Lin on 6/28/14.
//
//

#define imageWidth (80)

#import "KHCSlideTableViewCell.h"

@implementation KHCSlideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;

        // Initialize UI units
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth, 0, size.width - imageWidth - 2, size.height - 16.0)];
        self.pageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width-60, size.height - 10.0, 50, 16)];
        
        // Configure Main Label
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [self.titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.pageNumLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self.pageNumLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        // Add Main Label to Content View
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.pageNumLabel];
        
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.editing) {
        CGRect bounds = self.bounds;
        CGSize size = self.contentView.frame.size;
        self.imageView.frame = CGRectMake(bounds.origin.x + 2, 0, size.height, size.height);
        self.imageView.bounds = CGRectMake(bounds.origin.x + 2, 0, size.height, size.height);
    } else {
        CGSize size = self.contentView.frame.size;
        self.imageView.frame = CGRectMake(2, 0, size.height, size.height);
        self.imageView.bounds = CGRectMake(2, 0, size.height, size.height);
    }

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
