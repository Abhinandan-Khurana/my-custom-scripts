import json
import csv

# Function to read JSON data from a file
def read_json_file(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

# Function to write data to a CSV file
def write_csv_file(data, output_file):
    # Define CSV file fields
    fields = ["ip", "hostnames", "user_hostname", "port", "service", "cpes", "protocol", "product", "tags", "vulns", "start_time", "end_time", "os_name"]

    with open(output_file, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(fields)
        
        # Write data rows
        for entry in data:
            ip = entry.get("ip", "")
            hostnames = ";".join(entry.get("hostnames", []))
            user_hostname = entry.get("user_hostname", "")
            tags = ";".join(entry.get("tags", []))
            vulns = ";".join(entry.get("vulns", []))
            start_time = entry.get("start_time", "")
            end_time = entry.get("end_time", "")
            os_name = entry.get("os", {}).get("name", "")
            
            for port_info in entry.get("ports", []):
                port = port_info.get("port", "")
                service = port_info.get("service", "")
                cpes = ";".join(port_info.get("cpes", [])) if port_info.get("cpes") else ""
                protocol = port_info.get("protocol", "")
                product = port_info.get("product", "")
                
                csvwriter.writerow([ip, hostnames, user_hostname, port, service, cpes, protocol, product, tags, vulns, start_time, end_time, os_name])

# Main function to convert JSON to CSV
def main():
    # Prompt the user for the JSON input file path
    json_file_path = input("Enter the JSON input file path: ")
    # Prompt the user for the CSV output file path
    csv_file_path = input("Enter the CSV output file path: ")
    
    # Read JSON data
    data = read_json_file(json_file_path)
    
    # Write data to CSV
    write_csv_file(data, csv_file_path)

# Run the main function
if __name__ == "__main__":
    main()
