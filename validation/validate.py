import sys 
import requests
from bs4 import BeautifulSoup
import ast

found_detectors = sys.argv[1].replace('\n',' ').split(' ')
print('Found detectors:',found_detectors)

url = "https://cloud.google.com/security-command-center/docs/supported-iac-assets-policies#security-health-analytics-built-in-detectors"
response = requests.get(url)
soup = BeautifulSoup(response.content, "html.parser")

supported_detectors = []

sha_tag = soup.find("h3", {"id": "security-health-analytics-built-in-detectors"})
if sha_tag:
    ul_tag = sha_tag.find_next_sibling("ul")
    if ul_tag:
        for code_tag in ul_tag.find_all("code", translate="no", dir="ltr"):
            supported_detectors.append(code_tag.text.strip())

print('Supported detectors:',supported_detectors)


missing_detectors = list(set(supported_detectors) - set(found_detectors))
print('Missing detectors:',missing_detectors)