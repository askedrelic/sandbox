# great python tool

https://github.com/liyanage/omniplan-python/blob/master/omniplan.py


------------

my code


tell application "OmniPlan"
	set _window to front window
	
	set _document to document of _window
	set _project to project of my _document
	set _tasks to tasks of _project
	set selTasks to selected tasks of front window
	log _document
	
	-- set t to make new task with properties {name:"hi"} at end of tasks of g
	
	tell _document
		set thisOwner to "Unassigned"
		--set thisOwner to thisOwner as string
		
		if not (exists resource thisOwner) then
			make new resource with properties {name:thisOwner}
		end if
	end tell
end tell


-----------

-- Open and highlight only those notes containing a specified string

on run
	set strSearch to GetSearchString()
	if length of strSearch > 0 then
		
		tell application id "com.omnigroup.OmniPlan"
			set oWin to front window
			set oDoc to front document
			set oProject to project of oDoc
			
			tell oWin
				set selected tasks to {}
				set lstSeln to selected tasks
			end tell
			
			set note expanded of every task of oProject to false
			set lstTasks to my NoteMatchTasks(oProject, strSearch)
			repeat with oTask in lstTasks
				tell oTask
					-- set filtered to true -- FAILS ...
					set note expanded to true
				end tell
			end repeat
			set selected tasks of oWin to lstTasks
		end tell
	end if
end run

on NoteMatchTasks(oProject, strSearch)
	tell application id "com.omnigroup.OmniPlan"
		set lstTasks to tasks of oProject where note ≠ ""
		set lstMatch to {}
		repeat with oTask in lstTasks
			set strNote to note of oTask
			if (offset of strSearch in strNote) > 0 then set end of lstMatch to oTask
		end repeat
		return lstMatch
	end tell
end NoteMatchTasks


on GetSearchString()
	tell (display dialog "String to search for in notes: " default answer "")
		text returned
	end tell
end GetSearchString
