using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ExcelCore.Services;
using Microsoft.SqlServer.Dts.Pipeline;
using Microsoft.SqlServer.Dts.Pipeline.Wrapper;
using Microsoft.SqlServer.Dts.Runtime;
using Microsoft.SqlServer.Dts.Runtime.Wrapper;

namespace ExcelCore.Component
{
	[DtsPipelineComponent(DisplayName = "EOX Source Component"
		, Description = "Excel Open Xml Source Component for Dataflow Task- Developed by Louis Vu"
		, ComponentType = ComponentType.SourceAdapter)]
	public class ExcelComponent : PipelineComponent
	{
		private const string _SHEET_NAME_FIELD = "Sheet Name";
		private const string _FILE_PATH_VARIABLE_FIELD = "File Path Variable";

		public int[] mapOutputColsToBufferCols;
		public override void AcquireConnections(object transaction)
		{
			base.AcquireConnections(transaction);
		}
		public override void PrimeOutput(int outputs, int[] outputIDs, PipelineBuffer[] buffers)
		{
			base.PrimeOutput(outputs, outputIDs, buffers);

			IDTSOutput100 output = ComponentMetaData.OutputCollection.FindObjectByID(outputIDs[0]);
			PipelineBuffer buffer = buffers[0];

			String filePathVar = ComponentMetaData.CustomPropertyCollection[_FILE_PATH_VARIABLE_FIELD].Value.ToString();
			String sheetNameVar = ComponentMetaData.CustomPropertyCollection[_SHEET_NAME_FIELD].Value.ToString();
			DataTable dt = GetDataTableWithInputVar(filePathVar, sheetNameVar);
			
			foreach (DataRow row in dt.Rows)
			{
				buffer.AddRow();

				for (int x = 0; x < mapOutputColsToBufferCols.Length; x++)
				{
					if (row.IsNull(x))
						buffer.SetNull(mapOutputColsToBufferCols[x]);
					else
						buffer[mapOutputColsToBufferCols[x]] = row[x];
				}
			}

			buffer.SetEndOfRowset();
		}
		public override void PreExecute()
		{
			base.PreExecute();		
			
            IDTSOutput100 output = ComponentMetaData.OutputCollection[0];
            mapOutputColsToBufferCols = new int[output.OutputColumnCollection.Count];

            for (int i = 0; i < ComponentMetaData.OutputCollection[0].OutputColumnCollection.Count; i++)
			{				
				mapOutputColsToBufferCols[i] = BufferManager.FindColumnByLineageID(output.Buffer, output.OutputColumnCollection[i].LineageID);
			}
		}
		public override DTSValidationStatus Validate()
		{
			return base.Validate();
		}
		public override IDTSCustomProperty100 SetComponentProperty(string propertyName, object propertyValue)
		{
			DataTable dt = new DataTable();
			switch (propertyName)
			{
				case _FILE_PATH_VARIABLE_FIELD:
					dt = GetDataTableWithInputVar(propertyValue.ToString(), ComponentMetaData.CustomPropertyCollection[_SHEET_NAME_FIELD].Value.ToString());
					AddOutputColumns(dt);					
					break;
                case _SHEET_NAME_FIELD:
					if (ComponentMetaData.CustomPropertyCollection[_FILE_PATH_VARIABLE_FIELD].Value.ToString().Length > 0)
					{
						dt = GetDataTableWithInputVar(ComponentMetaData.CustomPropertyCollection[_FILE_PATH_VARIABLE_FIELD].Value.ToString(), propertyValue.ToString());
						AddOutputColumns(dt);
					}
                    break;
            }

			return base.SetComponentProperty(propertyName, propertyValue);
		}
		public override void ProvideComponentProperties()
		{
			ComponentMetaData.Name = "EOX Source Component";
			ComponentMetaData.Description = "Excel Open Xml Source Component for Dataflow Task- Developed by Louis Vu";
			ComponentMetaData.ContactInfo = "lamvt84@gmail.com";

			base.RemoveAllInputsOutputsAndCustomProperties();

			IDTSCustomProperty100 filePathVar = ComponentMetaData.CustomPropertyCollection.New();
			filePathVar.Description = "File path variable";
			filePathVar.Name = _FILE_PATH_VARIABLE_FIELD;
			filePathVar.Value = "";

            IDTSCustomProperty100 sheetNameVar = ComponentMetaData.CustomPropertyCollection.New();
            sheetNameVar.Description = "Sheet Name";
            sheetNameVar.Name = _SHEET_NAME_FIELD;
            sheetNameVar.Value = "";

            IDTSOutput100 output = ComponentMetaData.OutputCollection.New();
			output.Name = "Output";
		}
		public DataTable GetDataTableWithInputVar(String filePathVar, String sheetName)
        {
			IDTSVariables100 vars = null;
			VariableDispenser.LockForRead(filePathVar);			
			VariableDispenser.GetVariables(out vars);
			string filePath = (String)vars[filePathVar].Value;
			vars.Unlock();
			
			DataTable dt = ExcelService.ReadExcel(filePath, sheetName, 1);
			return dt;
		}
		public void AddOutputColumns(DataTable dt)
		{
			if (dt != null)
			{
				//Check if there are any rows in the datatable
				if (dt.Rows != null && dt.Rows.Count > 0)
				{
					DataTable schemaDT = dt.CreateDataReader().GetSchemaTable();
					ComponentMetaData.OutputCollection[0].OutputColumnCollection.RemoveAll();
					foreach (DataRow row in schemaDT.Rows)
					{
						IDTSOutputColumn100 outputCol = ComponentMetaData.OutputCollection[0].OutputColumnCollection.New();

						bool isLong = false;
						DataType dType = DataRecordTypeToBufferType((Type)row["DataType"]);
						dType = ConvertBufferDataTypeToFitManaged(dType, ref isLong);
						int length = ((int)row["ColumnSize"]) == -1 ? 1000 : (int)row["ColumnSize"];
						int precision = row["NumericPrecision"] is System.DBNull ? 0 : (short)row["NumericPrecision"];
						int scale = row["NumericScale"] is System.DBNull ? 0 : (short)row["NumericScale"];
						int codePage = schemaDT.Locale.TextInfo.ANSICodePage;

						switch (dType)
						{
							case DataType.DT_STR:
							case DataType.DT_TEXT:
								precision = 0;
								scale = 0;
								break;
							case DataType.DT_NUMERIC:
								length = 0;
								codePage = 0;
								if (precision > 38)
									precision = 38;
								if (scale > precision)
									scale = precision;
								break;
							case DataType.DT_DECIMAL:
								length = 0;
								precision = 0;
								codePage = 0;
								if (scale > 28)
									scale = 28;
								break;
							case DataType.DT_WSTR:
								precision = 0;
								scale = 0;
								codePage = 0;
								break;
							default:
								length = 0;
								precision = 0;
								scale = 0;
								codePage = 0;
								break;
						}

						outputCol.Name = row["ColumnName"].ToString();
						outputCol.SetDataTypeProperties(dType, length, precision, scale, codePage);
					}
				}
			}
		}
		private void LoggerError(string MessageText)
		{
			bool cancel = false;
			this.ComponentMetaData.FireError(0, this.ComponentMetaData.Name, MessageText, "", 0, out cancel);
		}
		private void Logger(string MessageText)
		{
			bool cancel = false;
			this.ComponentMetaData.FireInformation(0, this.ComponentMetaData.Name, MessageText, "", 0, ref cancel);
		}
	}
}
