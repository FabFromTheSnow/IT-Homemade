import tomllib
import sys 
import glob
import os

def check_valid(file_content):  
    present_fields = []
    required_fields = ["description", "name", "risk_score", "severity", "type", "query"]  
    missing_fields = []

    for table in file_content:
        for field in file_content[table]:
            present_fields.append(field)

    for field in required_fields:
        if field not in present_fields:
            missing_fields.append(field)

    if missing_fields:
        print(f"Missing fields: {missing_fields}")
    else:
        print("All good")

def check_file(file_path):
    """Check a single TOML file."""
    if not os.path.isfile(file_path):
        print(f"The file {file_path} does not exist.")
        return
    
    with open(file_path, "rb") as rule:
        try:
            file_content = tomllib.load(rule)
            print(f"\nChecking file: {file_path}")
            check_valid(file_content)
        except tomllib.TOMLDecodeError as e:
            print(f"Error decoding {file_path}: {e}")

def check_folder(file_path):
    """Check all TOML files in a folder."""
    folder = os.path.join(file_path, "*.toml")  
    toml_files = glob.glob(folder)
    
    if not toml_files:
        print("No .toml files found.")
        return

    for toml in toml_files:
        check_file(toml)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 valid.py <filepath> <rule or folderrules>")
    else:
        file_path = sys.argv[1]
        option = sys.argv[2]

        if option == "rule":
            check_file(file_path)
        elif option == "folderrules":
            check_folder(file_path)
        else:
            print("Invalid option. Use 'rule' for a single file or 'folderrules' for a folder.")
