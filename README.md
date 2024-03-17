# googlesheets-adapter

This package includes inbound and outbound adapters for Google Sheets, allowing respectively to save and retrieve data to/from Google Sheets documents.

The **outbound adapter** supports:

* Creating a new Google Sheets document
* Creating a new sheet in a Google Sheets document
* Adding or updating data in a specified range of cells
* Deleting data from Google Sheets
  
The **inbound adapter** monitors the appearance of new rows in a specified Google Sheets document and allows further processing of each new row. Each row must contain an identifier column.

The IPM package includes only adapter classes, while the GitHub repository also includes a demo example of the product.
