import pandas as pd
import pyodbc
import time

conn = pyodbc.connect(
    "Driver={SQL Server};Server=LAMVT1FINTECH\SQL2019;Database=StackOverflow2013;Trusted_Connection=yes;")
query = f"""
    SELECT Id AS UserId, DisplayName, Location FROM dbo.Users WHERE Location = '{'Helsinki, Finland'}'
"""
df_user = pd.read_sql(query, conn)

query = f"""
    SELECT UserId, Id, Score, Text, CreationDate FROM dbo.Comments
    WHERE CreationDate BETWEEN '{'2013-08-01'}' AND '{'2013-08-30'}'
"""
start = time.time()
df_comment = pd.read_sql_query(query, conn)
df_user.set_index('UserId')
df_comment.set_index('UserId')
df_result = pd.merge(df_user, df_comment, on='UserId').sort_values(
    by='Score', ascending=False)
end = time.time()
print(end - start)

df_result.to_csv("D:\\Repo\\Personal\\Github\\DevOps\\Python\\rs.csv"
                 , columns=["DisplayName", "UserId", "Id", "Score", "Text"]
                 , index=False)
