# UITableView

## General

1. Designated Initializer

   1. ```objective-c
      - (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
      ```

      > must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain

   2. ```objective-c
      - (nullable instancetype)initWithCoder:(NSCoder *)coder
      ```
   
   
   
3. style
   ```objective-c
   @property (nonatomic, readonly) UITableViewStyle style;
   ```



4. dataSource
   ```objective-c
   @property (nonatomic, weak, nullable) id <UITableViewDataSource> dataSource;
   ```
   
   
   
5. delegate
   ```objective-c
   @property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;
   ```
   



## Available at iOS(3.2)

6. backgroundView
   ```objective-c
   @property (nonatomic, strong, nullable) UIView *backgroundView;
   ```

   > the background view will be automatically resized to track the size of the table view.  this will be placed as a subview of the table view behind all cells and headers/footers.  default may be non-nil for some devices.
   
   
   
## Available at iOS(7.0)

7. estimatedRowHeight
   ```objective-c
   @property (nonatomic) CGFloat estimatedRowHeight;
   ```
   
   > default is UITableViewAutomaticDimension, set to 0 to disable
   
   
   
8. estimatedSectionHeaderHeight
   ```objective-c
   @property (nonatomic) CGFloat estimatedSectionHeaderHeight;
   ```
   
   > default is UITableViewAutomaticDimension, set to 0 to disable
   
   
   
9. estimatedSectionFooterHeight
   ```objective-c
   @property (nonatomic) CGFloat estimatedSectionFooterHeight;
   ```
   
   > default is UITableViewAutomaticDimension, set to 0 to disable
   
   
   
10. separatorInset
    ```objective-c
      @property (nonatomic) UIEdgeInsets separatorInset;
    ```

    > allows customization of the frame of cell separators; see also the separatorInsetReference property. Use UITableViewAutomaticDimension for the automatic inset for that edge.

   


## Available at iOS(11.0)

