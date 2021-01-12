using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

namespace ExcelCore.Utilities
{
    public static class ExcelUtility
    {
        private static string GetCellValue(WorkbookPart wbPart, List<Cell> theCells, string cellColumnReference)
        {
            Cell cell = null;
            string value = "";
            foreach (Cell c in theCells)
            {
                if (c.CellReference.Value.StartsWith(cellColumnReference))
                {
                    cell = c;
                    break;
                }
            }
            if (cell != null)
            {
                CellValue cellValue = cell.CellValue;
                string text = (cellValue == null) ? cell.InnerText : cellValue.Text;
                if (cell.DataType?.Value == CellValues.SharedString)
                {
                    text = wbPart.SharedStringTablePart.SharedStringTable.Elements<SharedStringItem>().ElementAt(Convert.ToInt32(cell.CellValue.Text)).InnerText;
                }
                string cellText = (text ?? string.Empty).Trim();

                if (cell.StyleIndex != null)
                {
                    CellFormat cellFormat = wbPart.WorkbookStylesPart.Stylesheet.CellFormats.ChildElements[int.Parse(cell.StyleIndex.InnerText)] as CellFormat;

                    if (cellFormat != null)
                    {
                        var dateFormat = GetDateTimeFormat(cellFormat.NumberFormatId);
                        if (!string.IsNullOrEmpty(dateFormat))
                        {
                            if (!string.IsNullOrEmpty(cellText))
                            {
                                if (double.TryParse(cellText, out var cellDouble))
                                {
                                    var theDate = DateTime.FromOADate(cellDouble);
                                    cellText = theDate.ToString(dateFormat);
                                }
                            }
                        }
                    }
                }

                value = cellText;              
            }
            return value;
        }

        private static string GetCellValue(WorkbookPart wbPart, List<Cell> theCells, int index)
        {
            return GetCellValue(wbPart, theCells, GetExcelColumnName(index));
        }

        private static string GetExcelColumnName(int columnNumber)
        {
            int dividend = columnNumber;
            string columnName = String.Empty;
            int modulo;
            while (dividend > 0)
            {
                modulo = (dividend - 1) % 26;
                columnName = Convert.ToChar(65 + modulo).ToString() + columnName;
                dividend = (int)((dividend - modulo) / 26);
            }
            return columnName;
        }

        //Only xlsx files
        public static DataTable GetDataTableFromExcelFile(string filePath, string sheetName = "", int type = 0)
        {
            DataTable dt = new DataTable();
            switch (type)
            {
                case 0:
                    dt = GetDataTableFromExcelFileType0(filePath, sheetName);
                    break;
                case 1:
                    dt = GetDataTableFromExcelFileType1(filePath, sheetName);
                    break;
            }
            return dt;
        }
        public static DataTable GetDataTableFromExcelFileType1(string filePath, string sheetName)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SpreadsheetDocument document = SpreadsheetDocument.Open(filePath, false))
                {
                    WorkbookPart wbPart = document.WorkbookPart;
                    IEnumerable<Sheet> sheets = document.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
                    string sheetId = sheetName != "" ? sheets.Where(q => q.Name == sheetName).First().Id.Value : sheets.First().Id.Value;
                    WorksheetPart wsPart = (WorksheetPart)wbPart.GetPartById(sheetId);
                    SheetData sheetdata = wsPart.Worksheet.Elements<SheetData>().FirstOrDefault();
                    IEnumerable<Row> rows = sheetdata.Descendants<Row>();                    
                    int totalHeaderCount = 0;
                    //Get the header                    
                    foreach (Row r in rows)
                    {
                        if (totalHeaderCount < r.Descendants<Cell>().Count()) totalHeaderCount = r.Descendants<Cell>().Count();
                    }
                    for (int i = 0; i < totalHeaderCount; i++)
                    {
                        dt.Columns.Add("c" + i.ToString());
                    }

                    foreach (Row r in rows)
                    {
                        DataRow tempRow = dt.NewRow();                       
                        for (int i = 1; i <= totalHeaderCount; i++)
                        {
                            tempRow[i - 1] = GetCellValue(wbPart, r.Elements<Cell>().ToList(), i);
                        }
                        dt.Rows.Add(tempRow);
                    }
                }
            }
            catch (Exception)
            {

            }
            return dt;
        }
        public static DataTable GetDataTableFromExcelFileType0(string filePath, string sheetName)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SpreadsheetDocument document = SpreadsheetDocument.Open(filePath, false))
                {
                    WorkbookPart wbPart = document.WorkbookPart;
                    IEnumerable<Sheet> sheets = document.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
                    string sheetId = sheetName != "" ? sheets.Where(q => q.Name == sheetName).First().Id.Value : sheets.First().Id.Value;
                    WorksheetPart wsPart = (WorksheetPart)wbPart.GetPartById(sheetId);
                    SheetData sheetdata = wsPart.Worksheet.Elements<SheetData>().FirstOrDefault();
                    int totalHeaderCount = sheetdata.Descendants<Row>().ElementAt(0).Descendants<Cell>().Count();
                    //Get the header                    
                    for (int i = 1; i <= totalHeaderCount; i++)
                    {
                        dt.Columns.Add(GetCellValue(wbPart, sheetdata.Descendants<Row>().ElementAt(0).Elements<Cell>().ToList(), i));
                    }
                    foreach (Row r in sheetdata.Descendants<Row>())
                    {
                        if (r.RowIndex > 0)
                        {
                            DataRow tempRow = dt.NewRow();

                            //Always get from the header count, because the index of the row changes where empty cell is not counted
                            for (int i = 1; i <= totalHeaderCount; i++)
                            {
                                tempRow[i - 1] = GetCellValue(wbPart, r.Elements<Cell>().ToList(), i);
                            }
                            dt.Rows.Add(tempRow);
                        }
                    }
                }
            }
            catch (Exception)
            {

            }
            return dt;
        }

        private static readonly Dictionary<uint, string> DateFormatDictionary = new Dictionary<uint, string>()
        {
            [14] = "dd/MM/yyyy",
            [15] = "d-MMM-yy",
            [16] = "d-MMM",
            [17] = "MMM-yy",
            [18] = "h:mm AM/PM",
            [19] = "h:mm:ss AM/PM",
            [20] = "h:mm",
            [21] = "h:mm:ss",
            [22] = "M/d/yy h:mm",
            [30] = "M/d/yy",
            [34] = "yyyy-MM-dd",
            [45] = "mm:ss",
            [46] = "[h]:mm:ss",
            [47] = "mmss.0",
            [51] = "MM-dd",
            [52] = "yyyy-MM-dd",
            [53] = "yyyy-MM-dd",
            [55] = "yyyy-MM-dd",
            [56] = "yyyy-MM-dd",
            [58] = "MM-dd",
            [165] = "M/d/yy",
            [166] = "dd MMMM yyyy",
            [167] = "dd/MM/yyyy",
            [168] = "dd/MM/yy",
            [169] = "d.M.yy",
            [170] = "yyyy-MM-dd",
            [171] = "dd MMMM yyyy",
            [172] = "d MMMM yyyy",
            [173] = "M/d",
            [174] = "M/d/yy",
            [175] = "MM/dd/yy",
            [176] = "d-MMM",
            [177] = "d-MMM-yy",
            [178] = "dd-MMM-yy",
            [179] = "MMM-yy",
            [180] = "MMMM-yy",
            [181] = "MMMM d, yyyy",
            [182] = "M/d/yy hh:mm t",
            [183] = "M/d/y HH:mm",
            [184] = "MMM",
            [185] = "MMM-dd",
            [186] = "M/d/yyyy",
            [187] = "d-MMM-yyyy"
        };

        private static string GetDateTimeFormat(UInt32Value numberFormatId)
        {
            return DateFormatDictionary.ContainsKey(numberFormatId) ? DateFormatDictionary[numberFormatId] : string.Empty;
        }
    }
}