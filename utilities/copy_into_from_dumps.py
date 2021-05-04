import os
import argparse


arguments_parser = argparse.ArgumentParser(description="Generate COPY Into scripts from Teradata DataDumps. Given a folder with some DataDumps a set of COPY INTO scripts to load into snowflake are generated")
arguments_parser.add_argument('--inputFolder', required=True, help='Folder with Datadumps')
arguments_parser.add_argument('--copyintoFolder', required=True, help='Folder for copyinto files')
arguments_parser.add_argument('--database', required=False, help='Teradata Database to filter. If missing all databases in the dump will be considered')
arguments = arguments_parser.parse_args()

print(f"Processing folder {arguments.inputFolder}")
if (arguments.database):
    print(f"Filtering on database: {arguments.database}")
os.makedirs(arguments.copyintoFolder, exist_ok=True)    
print(f"Copy into files folder: {arguments.copyintoFolder}")
#Transversing all the folders    
for dirpath, dirnames, files in os.walk(arguments.inputFolder):
    for file_name in files:
        if file_name.endswith(".dat"):
            # Teradata Exports have the .dat extension
            full_name = os.path.join(dirpath, file_name)
            database = file_name.split('.')[0]
            table_name = file_name.split('.')[1]
            if arguments.database and database != arguments.database:
               continue # skip if database argument was given and this file does not match the given database
            print(f"Processing {full_name}")
            target_file_name = os.path.join(arguments.copyintoFolder, database + "." + table_name + ".sql")
            with open(target_file_name,"w") as f:
                f.write(f""" PUT file://{full_name} INTO @{database}.%{table_name}; \n""")
                f.write(f""" COPY INTO {database}.{table_name} FROM @{database}.%{table_name} FILE_FORMAT=(TYPE=CSV); \n""")
print("Done")                
