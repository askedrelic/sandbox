-- This script is based on the code here: http://www.tuaw.com/2013/02/18/applescripting-omnifocus-send-completed-task-report-to-evernot/

-- Prepare a name for the new Evernote note
set theNoteName to "OmniFocus Completed Task Report"
set theNotebookName to ".Inbox"

-- Prompt the user to choose a scope for the report
-- activate
-- set theReportScope to choose from list {"Today", "Yesterday", "This Week", "Last Week", "This Month", "Last Month"} default items {"Yesterday"} with prompt "Generate a report for:" with title theNoteName
-- if theReportScope = false then return
-- set theReportScope to item 1 of theReportScope

-- Override default scope to last week
set theReportScope to "This Week"

-- Calculate the task start and end dates, based on the specified scope
set theStartDate to current date
set hours of theStartDate to 0
set minutes of theStartDate to 0
set seconds of theStartDate to 0
set theEndDate to theStartDate + (23 * hours) + (59 * minutes) + 59


-- Applescript is insanity
-- https://macscripter.net/viewtopic.php?id=24737
on date_format(old_date) -- Old_date is text, not a date.
   set {year:y, month:m, day:d} to date old_date
   tell (y * 10000 + m * 100 + d) as string to text 1 thru 4 & "/" & text 5 thru 6 & "/" & text 7 thru 8
end date_format

-- meh this doesn't work beacuse Applescript doesn't understand numeric months
on isoDate(theDate) -- theDate as datetime
    return year of theDate & "/" & month of theDate & "/" & day of theDate & ""
end isoDate

-- format task
on format_task(theCurrentTask) -- Task
    -- Append the tasks's name to the task list
    set data to "- " & name of theCurrentTask
    set data to data & " @done(" & my date_format(completion date of theCurrentTask as string) & ")"
    -- set data to data & " @due(" & my date_format(due date of theCurrentTask as string) & ")"
    set data to data & "\n"
    if text of note of theCurrentTask is not equal to "" then
        set data to data & "```\n" & note of theCurrentTask & "\n```\n"
    end if
    return data
end format_task

if theReportScope = "Today" then
    set theDateRange to date string of theStartDate
else if theReportScope = "Yesterday" then
    set theStartDate to theStartDate - 1 * days
    set theEndDate to theEndDate - 1 * days
    set theDateRange to date string of theStartDate
else if theReportScope = "This Week" then
    repeat until (weekday of theStartDate) = Sunday
        set theStartDate to theStartDate - 1 * days
    end repeat
    repeat until (weekday of theEndDate) = Saturday
        set theEndDate to theEndDate + 1 * days
    end repeat
    set theDateRange to (date string of theStartDate) & " through " & (date string of theEndDate)
else if theReportScope = "Last Week" then
    set theStartDate to theStartDate - 7 * days
    set theEndDate to theEndDate - 7 * days
    repeat until (weekday of theStartDate) = Sunday
        set theStartDate to theStartDate - 1 * days
    end repeat
    repeat until (weekday of theEndDate) = Saturday
        set theEndDate to theEndDate + 1 * days
    end repeat
    set theDateRange to (date string of theStartDate) & " through " & (date string of theEndDate)
else if theReportScope = "This Month" then
    repeat until (day of theStartDate) = 1
        set theStartDate to theStartDate - 1 * days
    end repeat
    repeat until (month of theEndDate) is not equal to (month of theStartDate)
        set theEndDate to theEndDate + 1 * days
    end repeat
    set theEndDate to theEndDate - 1 * days
    set theDateRange to (date string of theStartDate) & " through " & (date string of theEndDate)
else if theReportScope = "Last Month" then
    if (month of theStartDate) = January then
        set (year of theStartDate) to (year of theStartDate) - 1
        set (month of theStartDate) to December
    else
        set (month of theStartDate) to (month of theStartDate) - 1
    end if
    set month of theEndDate to month of theStartDate
    set year of theEndDate to year of theStartDate
    repeat until (day of theStartDate) = 1
        set theStartDate to theStartDate - 1 * days
    end repeat
    repeat until (month of theEndDate) is not equal to (month of theStartDate)
        set theEndDate to theEndDate + 1 * days
    end repeat
    set theEndDate to theEndDate - 1 * days
    set theDateRange to (date string of theStartDate) & " through " & (date string of theEndDate)
end if

-- Begin preparing the task list as HTML
set theProgressDetail to "# Completed Tasks\n" & theDateRange & "\n--------\n\n"
set theInboxProgressDetail to "\n"

-- Retrieve a list of projects modified within the specified scope
set modifiedTasksDetected to false
tell application "OmniFocus"
    tell front document
        set theModifiedProjects to every flattened project where its modification date is greater than theStartDate
        -- Loop through any detected projects
        repeat with a from 1 to length of theModifiedProjects
            set theCurrentProject to item a of theModifiedProjects
            -- Retrieve any project tasks modified within the specified scope
            set theCompletedTasks to (every flattened task of theCurrentProject where its completed = true and completion date is greater than theStartDate and completion date is less than theEndDate and number of tasks = 0)
            -- Loop through any detected tasks
            if theCompletedTasks is not equal to {} then
                set modifiedTasksDetected to true
                -- Append the project name to the task list
                set theProgressDetail to theProgressDetail & "## " & name of theCurrentProject & "\n"
                repeat with b from 1 to length of theCompletedTasks
                    set theCurrentTask to item b of theCompletedTasks
                    set theProgressDetail to theProgressDetail & my format_task(theCurrentTask)
                end repeat
                set theProgressDetail to theProgressDetail & "\n"
            end if
        end repeat
        -- Include the OmniFocus inbox
        set theInboxCompletedTasks to (every inbox task where its completed = true and completion date is greater than theStartDate and completion date is less than theEndDate and number of tasks = 0)
        -- Loop through any detected tasks
        if theInboxCompletedTasks is not equal to {} then
            set modifiedTasksDetected to true
            -- Append the project name to the task list
            set theInboxProgressDetail to theInboxProgressDetail & "## " & "Inbox" & "\n"
            repeat with d from 1 to length of theInboxCompletedTasks
                -- Append the tasks's name to the task list
                set theInboxCurrentTask to item d of theInboxCompletedTasks
                set theInboxProgressDetail to theInboxProgressDetail & "- " & name of theInboxCurrentTask & ""
                set theInboxProgressDetail to theInboxProgressDetail & " @done(" & my date_format(completion date of theInboxCurrentTask as string) & ")"
                -- set theInboxProgressDetail to theInboxProgressDetail & " @due(" & my date_format(due date of theInboxCurrentTask as string) & ")"
                set theInboxProgressDetail to theInboxProgressDetail & "\n"
                if note of theInboxCurrentTask is not equal to "" then
                    set theInboxProgressDetail to theInboxProgressDetail & "```\n" & note of theInboxCurrentTask & "\n```\n"
                end if
            end repeat
            set theInboxProgressDetail to theInboxProgressDetail & "\n"
        end if

    end tell
end tell
set theProgressDetail to theProgressDetail & theInboxProgressDetail & ""

-- Notify the user if no projects or tasks were found
if modifiedTasksDetected = false then
    display alert "OmniFocus Completed Task Report" message "No modified tasks were found for " & theReportScope & "."
    return
end if


-- Create the note in Evernote.
-- tell application "Evernote"
--     activate
--     set theReportDate to do shell script "date +%Y-%m-%d"
--     set theNote to create note notebook theNotebookName title theReportDate & " :: " & theNoteName with html theProgressDetail
--     open note window with theNote
-- end tell


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
set theFilePath to "/Users/mbehrens/Desktop/To Do List for " & dateYeartxt & "-" & dateMonthtxt & "-" & dateDaytxt & ".md"

--Export Task list to .MD file
on write_File(theFilePath, due_Tasks)
    set theText to due_Tasks
    set theFileReference to open for access theFilePath with write permission
    write theText to theFileReference as «class utf8»
    close access theFileReference
end write_File


set theReportDate to do shell script "date +%Y-%m-%d"
set theNote to theReportDate & " :: " & theNoteName & "\n" & theProgressDetail
my write_File(theFilePath, theNote)
