import json
import csv

#read file
with open('test.json', 'r') as jsonfile:
  data=jsonfile.read()

# parse file
jsonobj = json.loads(data)

def jsontocsv(input_json, output_path):
  keylist = []
  for key in jsonobj[0]:
    keylist.append(key)
    f = csv.writer(open(output_path, "w"))
    f.writerow(keylist)

  for record in jsonobj:
    currentrecord = []
    for key in keylist:
      currentrecord.append(record[key])
    f.writerow(currentrecord)
    
jsontocsv(jsonobj,'test.csv')