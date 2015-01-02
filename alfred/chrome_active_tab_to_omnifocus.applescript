on alfred_script(q)
(*
Chrome Active Tab to OmniFocus

Based upon this script:
http://veritrope.com/code/chrome-tab-list-to-omnifocus/

Terms of use:
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
*)

on alfred_script(q)
    
    set urlList to {}
    
    --SET DATE STAMP
    set the dateStamp to ((the current date) as string)
    set noteTitle to "URL List from Chrome Tabs on " & the dateStamp
    
    --PROCESSING FRONTMOST CHROME WINDOW
    tell application "Google Chrome"
        set successCount to 1
        set t to active tab of front window
        
        --GET TAB INFO
        set tabTitle to (title of t)
        set tabURL to (URL of t)
        set tabInfo to (tabTitle & return & tabURL)
        
        --ADD TO LIST
        copy tabInfo to the end of urlList
                
    end tell
    
    --MAKE INBOX ITEM IN OMNIFOCUS
    tell front document of application "OmniFocus"
        make new inbox task with properties {name:(noteTitle), note:urlList as text}
    end tell
    
    --NOTIFY RESULTS
    my notification_Center(1, 1)
    
end alfred_script

--NOTIFICATION CENTER
on notification_Center(successCount, itemNum)
    set Plural_Test to (successCount) as number
    
    if Plural_Test is -1 then
        display notification "No Tabs Exported!" with title "Send Chrome Tabs to OmniFocus"
        
    else if Plural_Test is 0 then
        display notification "No Tabs Exported!" with title "Send Chrome Tabs to OmniFocus"
        
    else if Plural_Test is equal to 1 then
        display notification "Successfully Exported " & itemNum & ¬
            " Tab to OmniFocus" with title "Send Chrome Tabs to OmniFocus"
        
    else if Plural_Test is greater than 1 then
        display notification "Successfully Exported " & itemNum & ¬
            " Tabs to OmniFocus" with title "Send Chrome Tabs to OmniFocus"
    end if
    
    set itemNum to "0"
    delay 1
end notification_Center
