############################################################

form Extract smaller files from large file
   sentence Directory_name: D:\VITS-tacotron2\SingingVoice-MFA-Training\SingingVoice-MFA-Training\original-textgrid
   sentence output_Directory_name: D:\VITS-tacotron2\SingingVoice-MFA-Training\SingingVoice-MFA-Training\split-textgrid
   positive Tier_number: 1
endform

############################################################

# Clear the info window
clearinfo

# Create a file list for all the recordings in the directory
Create Strings as file list: "fileList", directory_name$ + "/*.TextGrid"

# Select the file list and get how many files there are in the directory
select Strings fileList
num_file = Get number of strings

order =1

for i_file from 1 to num_file
	# Make sure the file list is selected before reading in sound files
	select Strings fileList
	current_file$ = Get string: i_file

	# Read in the sound file
	Read from file: directory_name$ + "/" + current_file$
	objectName$ = selected$("TextGrid", 1)

	textgridName$ = objectName$ + ".TextGrid"
	Read from file: directory_name$ + "/" + textgridName$

	intervalNums = Get number of intervals: tier_number
	for iInterval from 1 to intervalNums
		selectObject: "TextGrid " + objectName$
		start = Get start time of interval: tier_number, iInterval
		end = Get end time of interval: tier_number, iInterval
		intervalName$ = Get label of interval: tier_number, iInterval
		# If the label is not empty, then
		if intervalName$ <> "silence" and intervalName$ <> "" and intervalName$ <> "silence " and intervalName$ <> " silence"
			start = start
			end = end
			selectObject: "TextGrid " + objectName$
			Extract part: start, end, "no"
			# 
			temp = order
			ii = 0
			repeat
				temp = temp div 10
				ii = ii+1
			until temp = 0
			sumtemp = 6 - ii
			mark$ = ""
			for jjj from 1 to sumtemp
				mark$ = mark$ + "0"
			endfor
			mark$ = mark$ + string$(order)

			# Save the textgrid file in the same way
			selectObject: "TextGrid " + objectName$ + "_part"
			Save as text file: output_Directory_name$ + "/" + objectName$ + mark$ + ".TextGrid"
			selectObject: "TextGrid " + objectName$ + "_part"
			Remove
			order = order + 1

		# If the label is empty, then do nothing
		else
			#do nothing
		endif
	endfor
	selectObject: "TextGrid " + objectName$
	Remove
endfor

select all
Remove

printline Done!