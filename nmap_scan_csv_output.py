nmap_scan.py
import os
import pandas as pd
import xml.etree.ElementTree as ET
import getpass
import subprocess

# command
def run_nmap_scan(ip_file, xml_output, normal_output, password):
    # Nmap command with options including vulnerability scan
    nmap_command = f"sudo -S nmap -Pn -p- -T3 -sS -sV -O --script=vuln -iL {ip_file} -oX {xml_output} -oN {normal_output}"
    # Run the command with root privileges and capture the output
    process = subprocess.Popen(nmap_command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    stdout, stderr = process.communicate(password + '\n')

    # for normal file
    with open(normal_output, 'a') as normal_file:
        normal_file.write(stdout)
        if stderr:
            normal_file.write("\nErrors:\n")
            normal_file.write(stderr)

# XML -> csv
def convert_xml_to_csv(xml_output, csv_output):
    # Parse Nmap XML output
    tree = ET.parse(xml_output)
    root = tree.getroot()

    # data to dataFRamessss
    data = []
    for host in root.findall('host'):
        ip = host.find('address').get('addr')
        os_element = host.find('os')
        os = os_element.find('osmatch').get('name') if os_element is not None and os_element.find('osmatch') is not None else 'unknown'
        for port in host.find('ports').findall('port'):
            port_id = port.get('portid')
            state = port.find('state').get('state')
            service_element = port.find('service')
            service = service_element.get('name') if service_element is not None else 'unknown'
            version = service_element.get('version') if service_element is not None and 'version' in service_element.attrib else 'unknown'
            for script in port.findall('script'):
                vuln_id = script.get('id')
                vuln_output = script.get('output')
                data.append([ip, os, port_id, state, service, version, vuln_id, vuln_output])

    # saving the csv
    df = pd.DataFrame(data, columns=['IP', 'OS', 'Port', 'State', 'Service', 'Version', 'Vulnerability ID', 'Vulnerability Output'])
    df.to_csv(csv_output, index=False)

def main():
    # location and password
    ip_file = input("Enter the path to the file containing the list of IPs: ")
    xml_output = input("Enter the desired name for the XML output file: ")
    csv_output = input("Enter the desired name for the CSV output file: ")
    normal_output = input("Enter the desired name for the normal output file: ")
    password = getpass.getpass("Enter your root password: ")

    # Nmap scan
    print(f"Running Nmap scan on IPs listed in {ip_file}...")
    run_nmap_scan(ip_file, xml_output, normal_output, password)
    print(f"Nmap scan complete. Results saved in {xml_output} and {normal_output}")

    # XML --> CSV
    print(f"Converting Nmap XML output to CSV format...")
    convert_xml_to_csv(xml_output, csv_output)
    print(f"Conversion complete. Results saved in {csv_output}")

if __name__ == "__main__":
    main()
