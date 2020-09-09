using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SqlServer.Dts.Pipeline;
using Microsoft.SqlServer.Dts.Pipeline.Wrapper;
using Microsoft.SqlServer.Dts.Runtime;
using Microsoft.SqlServer.Dts.Runtime.Wrapper;
using System.ServiceModel.Syndication;
using System.Data;
using System.Xml;


namespace CustomSSISComponent
{
    [DtsPipelineComponent(DisplayName = "CustomSSISComponent", ComponentType = ComponentType.SourceAdapter, IconResource = "CustomSSISComponent.Resources.Icon1.ico")]
    public class CustomSSISComponent : PipelineComponent
    {
        public override void AcquireConnections(object transaction)
        {
            base.AcquireConnections(transaction);
        }
        public override void PrimeOutput(int outputs, int[] outputIDs, PipelineBuffer[] buffers)
        {
            base.PrimeOutput(outputs, outputIDs, buffers);

            IDTSOutput100 output = ComponentMetaData.OutputCollection.FindObjectByID(outputIDs[0]);
            PipelineBuffer buffer = buffers[0];

            DataTable dt = GetRSSDataTable(ComponentMetaData.CustomPropertyCollection["RSS Path"].Value.ToString());

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

        public int[] mapOutputColsToBufferCols;

        public override void PreExecute()
        {
            base.PreExecute();
            IDTSOutput100 output = ComponentMetaData.OutputCollection[0];
            mapOutputColsToBufferCols = new int[output.OutputColumnCollection.Count];

            for (int i = 0; i < ComponentMetaData.OutputCollection[0].OutputColumnCollection.Count; i++)
            {
                // Here, "i" is the column count in the component's outputcolumncollection
                // and the value of mapOutputColsToBufferCols[i] is the index of the corresponding column in the
                // buffer.
                mapOutputColsToBufferCols[i] = BufferManager.FindColumnByLineageID(output.Buffer, output.OutputColumnCollection[i].LineageID);
            }
        }

        public override DTSValidationStatus Validate()
        {
            return base.Validate();
        }
        public void AddOutputColumns(String propertyValue)
        {
            DataTable dt = GetRSSDataTable(propertyValue);
            if (dt != null)
            {
                //Check if there are any rows in the datatable
                if (dt.Rows != null && dt.Rows.Count > 0)
                {
                    DataTable schemaDT = dt.CreateDataReader().GetSchemaTable();
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

        public override IDTSCustomProperty100 SetComponentProperty(string propertyName, object propertyValue)
        {
            if (propertyName == "RSS Path" &&
        ComponentMetaData.OutputCollection[0].OutputColumnCollection.Count == 0)
            {
                AddOutputColumns(propertyValue.ToString());
            }

            return base.SetComponentProperty(propertyName, propertyValue);
        }

        public override void ProvideComponentProperties()
        {
            base.ProvideComponentProperties();
            base.RemoveAllInputsOutputsAndCustomProperties();

            IDTSCustomProperty100 rsspath = ComponentMetaData.CustomPropertyCollection.New();
            rsspath.Description = "The path of the RSS feed";
            rsspath.Name = "RSS Path";
            rsspath.Value = String.Empty;

            IDTSOutput100 output = ComponentMetaData.OutputCollection.New();
            output.Name = "Output";
        }

        public DataTable GetRSSDataTable(String propertyValue)
        {
            DataTable dt = new DataTable();
            try
            {
                XmlReader reader = XmlReader.Create(propertyValue);
                SyndicationFeed feed = SyndicationFeed.Load(reader);

                dt.Columns.Add("Title", Type.GetType("System.String"));
                dt.Columns.Add("PublishDate", Type.GetType("System.DateTime"));
                dt.Columns.Add("URL", Type.GetType("System.String"));

                foreach (SyndicationItem item in feed.Items)
                {
                    DataRow dRow = dt.NewRow();
                    dRow["Title"] = item.Title.Text;
                    dRow["PublishDate"] = item.PublishDate.DateTime;
                    dRow["URL"] = item.Id;
                    dt.Rows.Add(dRow);
                }

                return dt;
            }
            catch (Exception e)
            {
                throw e;
            }

        }


    }
}
