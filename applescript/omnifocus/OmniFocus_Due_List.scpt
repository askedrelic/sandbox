(*
File: OmniFocus_Due_List.scpt
Revision: 1.0
Revised: 2015-07-01

Summary: Create taskpaper list of tasks due +/- 7d from current date.

-----------------------------------------------------------

Script based on Justin Lancy (@veritrope) from Veritrope.com
http://veritrope.com/code/write-todays-completed-tasks-in-omnifocus-to-a-text-file

*)

--Set Date Functions
set CurrDate to date (short date string of (current date))
set CurrDatetxt to short date string of date (short date string of (current date))

set endDate to (current date) + (7 * days)
set endDatetxt to date (short date string of (endDate))

set dateYeartxt to year of (current date) as integer
set dateMonthtxt to month of (current date) as integer
set dateDaytxt to day of (current date) as integer

if dateMonthtxt < 10 then
	set dateMonthtxt to "0" & dateMonthtxt
end if

if dateDaytxt < 10 then
	set dateDaytxt to "0" & dateDaytxt
end if

--Set File/Path name of MD file
set theFilePath to choose file name default name "To Do List for " & dateYeartxt & "-" & dateMonthtxt & "-" & dateDaytxt & ".md"

--Get OmniFocus task list
set due_Tasks to my OmniFocus_task_list()

--Output .MD text file
my write_File(theFilePath, due_Tasks)

--Set OmniFocus Due Task List
on OmniFocus_task_list()
	set endDate to (current date) + (7 * days)
	set startDate to (current date) - (7 * days)
	set CurrDate to date (short date string of (startDate))
	set CurrDatetxt to short date string of date (short date string of (current date))
	set endDatetxt to date (short date string of (endDate))
	tell application "Omnifocus"
		tell default document
			set refDueTaskList to a reference to (flattened tasks where (due date ≥ CurrDate and due date < endDatetxt))
			set {lstName, lstContext, lstProject} to {name, name of its context, name of its containing project} of refDueTaskList
			set strText to "To Do List for " & CurrDatetxt & ":" & return & return
			repeat with iTask from 1 to count of lstName
				set {strName, varContext, varProject} to {item iTask of lstName, item iTask of lstContext, item iTask of lstProject}
				set strText to strText & "▢ " & strName
				if varContext is not missing value then set strText to strText & " @" & varContext
				if varProject is not missing value then set strText to strText & " (" & varProject & ")"
				set strText to strText & return
			end repeat
		end tell
	end tell
	strText
end OmniFocus_task_list

--Export Task list to .MD file
on write_File(theFilePath, due_Tasks)
	set theText to due_Tasks
	set theFileReference to open for access theFilePath with write permission
	write theText to theFileReference as «class utf8»
	close access theFileReference
end write_File
