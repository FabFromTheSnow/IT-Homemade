import tomllib
import sys 

def check_valid(file):
    present_fields = []
    required_fields = ["description", "name", "risk_score", "severity", "type", "query"]  
    missing_fields = []

    # Print the dictionary directly
    for table in file:
        for field in file[table]:
            present_fields.append(field)

    for field in required_fields:
        if field not in present_fields:
            missing_fields.append(field)

    if missing_fields:
        print(f"Missing fields: {missing_fields}")
    else:
        print("All good")


if sys.argv[1:] == []:
    print("Usage : python3 valid.py <filepath>")
else:
    file_path = sys.argv[1]
    with open(file_path, "rb") as rule:
        try:
            file = tomllib.load(rule)  
            check_valid(file)
        except tomllib.TOMLDecodeError as e:
            print(e)
    
    
