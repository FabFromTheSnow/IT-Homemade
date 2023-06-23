import os
import random
import subprocess
import re

values_tuple = (
    'al', 'ar', 'au', 'ba', 'be', 'bg', 'br', 'ca', 'ch', 'cl', 'co', 'cr', 'cy', 'cz', 'de', 'dk', 'ee', 'es',
    'fi', 'fr', 'ge', 'gr', 'hk', 'hr', 'hu', 'id', 'ie', 'il', 'is', 'it', 'jp', 'kr', 'lt', 'lu', 'lv', 'md',
    'mk', 'mx', 'my', 'nl', 'no', 'nz', 'ov', 'pl', 'pt', 'ro', 'rs', 'se', 'sg', 'si', 'sk', 'th', 'tr', 'tw',
    'ua', 'uk', 'us', 'vn', 'za'
)

country_names = [
    'Albania', 'Argentina', 'Australia', 'Bosnia and Herzegovina', 'Belgium', 'Bulgaria', 'Brazil', 'Canada',
    'Switzerland', 'Chile', 'Colombia', 'Costa Rica', 'Cyprus', 'Czech Republic', 'Germany', 'Denmark', 'Estonia',
    'Spain', 'Finland', 'France', 'Georgia', 'Greece', 'Hong Kong', 'Croatia', 'Hungary', 'Indonesia', 'Ireland',
    'Israel', 'Iceland', 'Italy', 'Japan', 'South Korea', 'Lithuania', 'Luxembourg', 'Latvia', 'Moldova',
    'North Macedonia', 'Mexico', 'Malaysia', 'Netherlands', 'Norway', 'New Zealand', 'OverVPN', 'Poland', 'Portugal',
    'Romania', 'Serbia', 'Sweden', 'Singapore', 'Slovenia', 'Slovakia', 'Thailand', 'Turkey', 'Taiwan', 'Ukraine',
    'United Kingdom', 'United States', 'Vietnam', 'South Africa'
]

# Display country options
print("Country Options:")
for index, country_code in enumerate(values_tuple, start=1):
    country_name = country_names[index - 1]
    print(f"{index}. {country_code} - {country_name}")

selection = input("Enter the number of the country: ")
try:
    selection = int(selection)
    if 1 <= selection <= len(values_tuple):
        country_code = values_tuple[selection - 1]
        print(f"Selected country code: {country_code}")
        # Perform actions with the selected country code
    else:
        print("Invalid selection. Please enter a valid number.")
except ValueError:
    print("Invalid input. Please enter a valid number.")


command = f"find ./vpn -name '{country_code}*' | grep -oE '[0-9]+'"
output = subprocess.check_output(command, shell=True, text=True).strip()
numbers1 = [int(number) for number in re.findall(r'\d+', output)]



command2 = f"find ./vpn -name '{country_code}*' | grep -oE '[0-9]+'"
output2 = subprocess.check_output(command2, shell=True, text=True).strip()
numbers2 = [int(number) for number in re.findall(r'\d+', output2)]

lowest_number = min(numbers2)

max_number = max(numbers2)
if max_number == 443:
    second_largest = float('-inf')  # Initialize with negative infinity
    for num in numbers2:
        if num != max_number and num > second_largest:
            second_largest = num

    max_number = second_largest


SelectedNBR = random.randint(lowest_number, max_number)

config_file = "./vpn/" + country_code + str(SelectedNBR) + ".nordvpn.com.tcp443.ovpn"

command3 = f"openvpn --config {config_file} --auth-user-pass vplog"
process = subprocess.Popen(command3, shell=True)


