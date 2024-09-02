#!/bin/bash

# Check if the pcap file path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <$1>"
  exit 1
fi

# Input: Path to the Wireshark pcap file
pcap_file="$1"

# Function to extract information from the pcap file
analyze_traffic() {
  # Counting total packets
  total_packets=$(tshark -r "$pcap_file" | wc -l)

  # Counting HTTP packets
  http_packets=$(tshark -r "$pcap_file" -Y "http" | wc -l)

  # Counting HTTPS/TLS packets
  https_packets=$(tshark -r "$pcap_file" -Y "tls" | wc -l)

  # Finding top 5 source IP addresses
  top_source_ips=$(tshark -r "$pcap_file" -T fields -e ip.src | sort | uniq -c | sort -nr | head -5| awk '{print "- "$2": "$1" packets"}')
  # Finding top 5 destination IP addresses
  top_dest_ips=$(tshark -r "$pcap_file" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -5| awk '{print "- "$2": "$1" packets"}') 

  # Output analysis summary
  echo "----- Network Traffic Analysis Report -----"
  echo ""
  echo "1. Total Packets: $total_packets"
  echo ""
  echo "2. Protocols:"
  echo "  - HTTP: $http_packets packets"
  echo "  - HTTPS/TLS: $https_packets packets"
  echo ""
  echo "3. Top 5 Source IP Addresses:"
  echo "$top_source_ips"
  echo ""
  echo "4. Top 5 Destination IP Addresses:"
  echo "$top_dest_ips"
  echo ""
  echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic