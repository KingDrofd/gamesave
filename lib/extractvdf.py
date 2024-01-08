import re

data = '''
"1888160"
{
	"ChangeNumber"		"-5290410625508448626"
	"ostype"		"20"
	"ArmoredCore6/76561198404081394/AC60000.sl2"
	{
		"root"		"4"
		"size"		"30819552"
		"localtime"		"1704579385"
		"time"		"1704579387"
		"remotetime"		"1704579387"
		"sha"		"31bab7b55f243a7ad07c0f133c20418a6b4c934a"
		"syncstate"		"1"
		"persiststate"		"0"
		"platformstosync2"		"1"
	}
}
'''

# Define the regular expression pattern
path_pattern = re.compile(r'"([^"]+?)/[^"]+"')
root_pattern = re.compile(r'"root"\s+"(\d+)"')
size_pattern = re.compile(r'"size"\s+"(\d+)"')

# Extract the path and root value using the patterns
path_match = path_pattern.search(data)
root_match = root_pattern.search(data)
size_match = size_pattern.search(data)

# Get the matched values
path = path_match.group(1) if path_match else None
root = root_match.group(1) if root_match else None
size = size_match.group(1) if size_match else None

# Print the results
print("Path:", path)
print("Root:", root)
print("Size:", size)