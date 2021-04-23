## I order to run this script you might need to install the connector and its dependencies
## you might need to do pip install "snowflake-connector-python[secure-local-storage,pandas]"

import snowflake.connector

import argparse


arguments_parser = argparse.ArgumentParser(description="Generate Update Scripts to apply TRIM to all TEXT columns for an Snowflake DB")
arguments_parser.add_argument('--account', required=True, help='Snowflake account name')
arguments_parser.add_argument('--database', required=True, help='Snowflake database')
arguments_parser.add_argument('--role', required=True, help='Snowflake role')
arguments_parser.add_argument('--user', required=True, help='Snowflake account user')
arguments_parser.add_argument('--password', required=True, help='Snowflake account password')
arguments_parser.add_argument('--warehouse', required=True, help='Snowflake warehouse')


arguments = arguments_parser.parse_args()
print("Connecting to the database")
ctx = snowflake.connector.connect(
    user=arguments.user,
    password=arguments.password,
    account=arguments.account,
    warehouse=arguments.warehouse,
    database=arguments.database,
    role=arguments.role
    )

cur = ctx.cursor()
sql = """
    SELECT 
        Cols.TABLE_NAME, 
        Cols.TABLE_SCHEMA, 
        Cols.COLUMN_NAME, 
        Cols.CHARACTER_MAXIMUM_LENGTH 
    FROM
        INFORMATION_SCHEMA.TABLES AS Tables
    INNER JOIN 
        INFORMATION_SCHEMA.COLUMNS AS Cols 
    ON 
        Cols.TABLE_NAME = Tables.TABLE_NAME 
        AND 
        Cols.TABLE_SCHEMA = Tables.TABLE_SCHEMA
        
    WHERE Tables.TABLE_TYPE = 'BASE TABLE'
    ORDER BY Cols.TABLE_NAME, Cols.TABLE_SCHEMA;
"""
print("Collection columns information")
cur.execute(sql)

df = cur.fetch_pandas_all()

print("Generating updates")
with open("trim_updates.sql","w") as f:
    for name, group in df.groupby(['TABLE_NAME', 'TABLE_SCHEMA']):
        (table_name, table_schema) = name
        columns = group['COLUMN_NAME'].tolist()
        columns_count = len(columns)
        print(f"Generating update for table {name}")
        update_sql = f"UPDATE {arguments.database}.{table_schema}.{table_name} SET \n"
        i = 0
        while i < columns_count:
            column_name = columns[i]
            comma = ",\n"
            if i == columns_count -1:
                comma = ""
            update_sql = update_sql + f'     "{column_name}" = TRIM("{column_name}"){comma}'
            i = i + 1
        update_sql = update_sql + ";\n\n"
        f.write(update_sql)
    

