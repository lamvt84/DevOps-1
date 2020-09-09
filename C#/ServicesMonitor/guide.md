# Create Task schedule

## Step 1

Edit TaskTemplate.xml

Look for <Actions Context="Author">

Modify the <argument> values with physical path of "CallApiHealthCheck" file

## Step 2

Edit CallApiHealthCheck.ps1

Modify Url variable with right value

## Step 3

Execute CreateTask.ps1 in Administrator mode

## Step 4

Verify task created result in Windows Task schedule