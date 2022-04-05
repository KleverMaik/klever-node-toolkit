
#!/usr/bin/python3

# Retrieve the status of all Klever Validator Nodes(elected, eligible, jailed, waiting, inactive)
# This script reads the validators.txt file that contains the output from curl http://YOURIP:8080/validator/statistics
## when called in klever-node-fetcher.sh
# Written by JP @ theklevernator.com - 2022

# Set the status metrics
elected_status = 'elected'
eligible_status = 'eligible'
jailed_status = 'jailed'
waiting_status = 'waiting'
inactive_status = 'inactive'

# Open text file in read only mode
file = open("/home/jessep21/klever/scripts/flask/validators.txt", "r")

# Reading data of the file
read_data = file.read()

# Converting data in lower case and the counting the occurrence
word_count = read_data.lower().count(elected_status)
print(f"{elected_status}_nodes {word_count}\n")
word_count = read_data.lower().count(eligible_status)
print(f"{eligible_status}_nodes {word_count}\n")
word_count = read_data.lower().count(jailed_status)
print(f"{jailed_status}_nodes {word_count}\n")
word_count = read_data.lower().count(waiting_status)
print(f"{waiting_status}_nodes {word_count}\n")
word_count = read_data.lower().count(inactive_status)
print(f"{inactive_status}_nodes {word_count}")