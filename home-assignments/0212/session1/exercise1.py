import json
import yaml

# Run 'pip3 install pyyaml' in command prompt to import the yaml module to import/export file

# Open and load the json file 
with open('my_list.json', 'r') as f:
    mydict = json.load(f)
   
    # Get oldest person age
    name_ages = mydict['ppl_ages']
    oldest = sorted(name_ages.values())[-1]
    
    # Creating list of group ages according to ages in buckets [[11,20],[20-25],...]
    group_age = []
    buckets = sorted(mydict['buckets'])    
    for i in range(len(buckets)-1):
        group_age.append(buckets[i:i+2])
    # Inserting first age list [0-11]
    group_age.insert(0, list((0, buckets[0])))
    # Appending a list containing last age in bucket and the oldest person age
    group_age.append(list((buckets[i+1], oldest)))
    
    # Names ages will be checked against the group ages interval and names will be added to relevant group ages 
    newdict = {}
    for i in range(len(group_age)):                         # group_age list
        namelist= []                                        # namelist is reset for each group_age group 
        for name, age in name_ages.items():                 # name_ages dictionary   
            if age >= group_age[i][0] and age < group_age[i][1]:    # if the age is between the ages in the group then add to namelist
                namelist.append(":"+name)
        group_key=f'{group_age[i][0]}-{group_age[i][1]}'    # f strings for formatting
        newdict[group_key] = namelist                       # adding to dictionary the namelist
    print(yaml.dump(newdict, default_flow_style=False, allow_unicode=True))     # output in yaml format
