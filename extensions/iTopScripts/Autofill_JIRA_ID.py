#!/usr/bin/python

import json
import requests
import re
import sys
#Requires requests module
#May require regex module

ITOP_URL = None
ITOP_USER = None
ITOP_PWD = None
OBJECT_CLASS = "ApplicationSolution"

if len(sys.argv) != 4:
	print("Incorrect amount of provided arguments.\n")
	print("Please ensure that the provided arguments is structured as the following: iTop URL, Account Username, Account Password.\n")
	sys.exit()
else:
	ITOP_URL = sys.argv[1]
	ITOP_USER = sys.argv[2]
	ITOP_PWD = sys.argv[3]

description = None
appName = None
id = None
 
json_data = {
		'operation': "core/get",
		'class': OBJECT_CLASS,
		'key': "SELECT ApplicationSolution WHERE description LIKE '%Departmenatl ID:%' OR description LIKE '%Jira Key:%'",
		'output_fields': "name, description, Jira_Dep_ID"
}
encoded_data = json.dumps(json_data)
r = requests.post(ITOP_URL+'/webservices/rest.php?version=1.4', verify=True, data={'auth_user': ITOP_USER, 'auth_pwd': ITOP_PWD, 'json_data': encoded_data})
result = r.json();

for key, value in result["objects"].items():
	description = result["objects"][key]["fields"]["description"]
	appName = result["objects"][key]["fields"]["name"]	
	if description.find("departmenatl id:") or description.find("departmental id:"):
		descEveryWord = re.split("\s", description)
		for index, val in enumerate(descEveryWord):
			if val.upper() == "ID:":
				id = descEveryWord[index + 1]
				break
	elif description.find("jira key:"):
		descEveryWord = re.split("\s", description)
		for index, val in enumerate(descEveryWord):
			if val.upper() == "KEY:":
				id = descEveryWord[index + 1]
				break
				
	print ("\nThis is the JIRA KEY/DEP ID:", id)

	if id is None:
		print ("There is no JIRA KEY/DEP. ID. As such, no field has been filled out.\n");
	else:
		json_data = {
				'operation': "core/update",
				"comment": "Testing Python Script for AutoUpdate",
				'class': OBJECT_CLASS,
				'key': 
				{
					'name': appName
				},
				'output_fields': "name, description, Jira_Dep_ID",
				"fields":
				{
					'Jira_Dep_ID': id
				}
		}

		encoded_data = json.dumps(json_data)
		r = requests.post(ITOP_URL+'/webservices/rest.php?version=1.4', verify=True, data={'auth_user': ITOP_USER, 'auth_pwd': ITOP_PWD, 'json_data': encoded_data})
		newResult = json.loads(r.text);

		if newResult['code'] == 0:
			print("JIRA ID has been updated.")
		else:
			print(newResult['message'])
