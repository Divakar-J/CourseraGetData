##  Tidy data assignment
  
### Summary
  There are 8 datasets for the project  . 2 datasets features,activity_labels  are common for both test and training. Test and training contains 3 datasets each for X , Y and sujects
  
### Step 1: Read required data sets
bind subject , y and x data (561 columns) for test and training
Add a new column  ActitvityLabel . This column is poulated with ActitvityLabel for corresponding ActivityCode
  
### Step 2: Add column names . 
  
Get transposed column names from feature for 561 columns of x data . column names for subject and y are added manually
  
### Step 3 :Column Bind  subject , y and x data
  
Prepare a single data from subject , activity label, y , x  using cbind

### Step 4 :Extract only required columns . 
  
x data contains 561 columns . only columns that contain mean() or std() are extracted . grep is used for filtering

### Step 5:Prepare tidy data
  
Aggregate function is used to in this step. Data is grouped by Subject and activity type . Final data contains 180 rows ( 30 subjects * 6 activity types)
Write to text file using write.table



