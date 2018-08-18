	set filePath to "/Users/JoeBuhlig/Dropbox/Text/TaskReports/" -- Where to save the resulting text file (Be sure to add the trailing "/")
	
	-- Create the new filename as YYYYMMDD.txt
	set todayDate to current date
	set yestDate to todayDate - 1 * days
	set {year:y, month:m, day:d} to yestDate
	set fileName to y * 10000
	set fileName to fileName + (m * 100)
	set fileName to fileName + d
	
	-- Set the starting date of the report
	set startDate to todayDate - 1 * days
	set startDate's hours to 0
	set startDate's minutes to 0
	set startDate's seconds to 0
	
	-- Set the ending date of the report
	set endDate to todayDate - 1 * days
	set endDate's hours to 23
	set endDate's minutes to 59
	set endDate's seconds to 59
	
	-- Create the blank report to build from
	set reportText to ""
	
	tell application "OmniFocus"
		tell front document
			set theProjects to every flattened project where its modification date is greater than startDate and modification date is less than endDate
			repeat with a from 1 to length of theProjects
				set currentProj to item a of theProjects
				set theTasks to (every flattened task of currentProj where its completed = true and completion date is greater than startDate and completion date is less than endDate)
				if theTasks is not equal to {} then
					set reportText to reportText & return & return & "------------------------------" & return & name of currentProj & return
					repeat with b from 1 to length of theTasks
						set currentTask to item b of theTasks
						set completedDate to completion date of currentTask
						set completedTime to time string of completedDate
						set reportText to reportText & return & name of currentTask & " ----- " & completedTime
					end repeat
				end if
			end repeat
			if reportText is equal to "" then
				reportText = "Nothing completed for this day."
			end if
			set runTime to date string of (todayDate - 1 * days)
			set reportText to runTime & return & return & reportText
			set newFile to open for access filePath & fileName & ".txt" with write permission
			write reportText to newFile
			close access newFile
		end tell -- end tell front document
	end tell -- end tell application "OmniFocus"