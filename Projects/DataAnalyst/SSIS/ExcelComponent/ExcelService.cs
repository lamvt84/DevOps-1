using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ExcelCore.Utilities;

namespace ExcelCore.Services
{
    public static class ExcelService
    {
		public static DataTable ReadExcel(String filePath, string sheetName = "", int type = 0)
		{
			DataTable dt = new DataTable();
			try
			{
				dt = ExcelUtility.GetDataTableFromExcelFile(filePath, sheetName, type);

				return dt;
			}
			catch (Exception e)
			{
				throw e;
			}
		}
	}	
}
