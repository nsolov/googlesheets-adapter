# googlesheets-adapter

This package includes inbound and outbound adapters for Google Sheets, allowing respectively to save and retrieve data to/from Google Sheets documents.

The **outbound adapter** supports:

* Creating a new Google Sheets document
* Creating a new sheet in a Google Sheets document
* Adding or updating data in a specified range of cells
* Deleting data from Google Sheets
  
The **inbound adapter** monitors the appearance of new rows in a specified Google Sheets document and allows further processing of each new row. Each row must contain an identifier column.

The IPM package includes only adapter classes, while the GitHub repository also includes a demo example of the product.

## Get a GoogleSheets API KEY

1. Create a new project using Google Cloud Console(GCP) (https://console.cloud.google.com/)

2. Select your project
   
   <img src="https://nsolov.com/img/adapter/image6.png" width="90%">
   
3. Enable access to Google Sheets and Google Drive API

  <img src="https://nsolov.com/img/adapter/image2.png" width="50%">
  
  Enable **Google Sheets API** and **Google Drive API**

4. Creatе Google Service Account

   APIs and Services -> Credentials
   <img src="https://nsolov.com/img/adapter/image5.png" width="90%">

* First step - specify the name of the Service account
* Second step - Select Role “Editor”
* Third step - optional - skip it

5. Create API keys

Click on the service account to configure it. 

Copy somewhere the service account’s email - you will use it later.

Go to Keys tab and click “Add Key” and then “Create New Key”
Select “JSON” and download created file. 


## Demo

In this example, the business service utilizes an incoming Google Sheets adapter to detect new rows in the document on the specified sheet. It processes the received data from each row and invokes the `GoogleSheets.BusinessOperation` business operation to write data to a new sheet in the same document.

One column of the document (the sheet with the original data) must contain a unique identifier for each row, ensuring that each row is processed only once. Additionally, the row must contain one or more cells with numerical data.

When the adapter detects a new row, it passes this row to the business service. The business service calculates the sum of all the numbers in the row (excluding the ID column) and generates a new row containing the sum of values and the current date. These data will be passed to the business operation for writing to the Google Sheets document.

To run the demo:

1. Create and share your document with the service account
   
   1.1. Create GoogleSheet document
   
   1.2. Save ID of the document somewhere - you will use it later
   
   1.3. Share using service account’s email and give role “Editor”

3. Run demo
