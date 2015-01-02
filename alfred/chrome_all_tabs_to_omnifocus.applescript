on alfred_script(q)
(*
◸ Veritrope.com
Chrome URLs List to OmniFocus
VERSION 1.1
June 15, 2014

// UPDATE NOTICES
    ** Follow @Veritrope on Twitter, Facebook, Google Plus, and ADN for Update Notices! **

// SUPPORT VERITROPE!
    If this AppleScript was useful to you, please take a second to show your love here: 
    http://veritrope.com/support

// SCRIPT INFORMATION AND UPDATE PAGE
    http://veritrope.com/code/chrome-tab-list-to-omnifocus/

    BASED ON THIS SAFARI/EVERNOTE SCRIPT:
    http://veritrope.com/code/export-all-safari-tabs-to-evernote/

    …AND THIS SAFARI/OMNIFOCUS SCRIPT:
    http://veritrope.com/code/safari-tab-list-to-omnifocus/

    WITH GREAT THANKS TO BRETT TERPSTRA, ZETTT, AND GORDON!

// REQUIREMENTS
    More details on the script information page.

// CHANGELOG
    1.10    FIX FOR DATE STAMP + CHANGE IN OF'S APPLESCRIPT, ADDED NOTIFICATION CENTER, REMOVED LOGGING, ADDED COMMENTS
    1.00    INITIAL RELEASE

// TERMS OF USE:
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

*)

(* 
======================================
// OTHER PROPERTIES (USE CAUTION WHEN CHANGING)
======================================
*)

--RESET
set urlList to {}
set currentTab to 0

(* 
======================================
// MAIN PROGRAM 
======================================
*)
--SET DATE STAMP
set the dateStamp to ((the current date) as string)
set noteTitle to "URL List from Chrome Tabs on " & the dateStamp

--PROCESSING FRONTMOST CHROME WINDOW
tell application "Google Chrome"
    
    set chromeWindow to the front window
    set tabCount to (count of (tabs of chromeWindow))
    set successCount to 0
    
    try
        repeat with t in (tabs of chromeWindow)
            set currentTab to currentTab + 1
            
            --GET TAB INFO
            set tabTitle to (title of t)
            set tabURL to (URL of t)
            
            if currentTab is not equal to tabCount then
                set tabInfo to (tabTitle & return & tabURL & return & return)
            else
                -- don't output double return on last tab
                set tabInfo to (tabTitle & return & tabURL)
            end if
            
            --ADD TO LIST
            copy tabInfo to the end of urlList
            
            --INCREMENT SUCCESS COUNT
            set successCount to (successCount + 1)
            
        end repeat
    end try
end tell

--MAKE INBOX ITEM IN OMNIFOCUS
tell front document of application "OmniFocus"
    make new inbox task with properties {name:(noteTitle), note:urlList as text}
end tell

--NOTIFY RESULTS
my notification_Center(successCount, tabCount)


end alfred_script
(* 
======================================
// NOTIFICATION SUBROUTINE
======================================
*)

--NOTIFICATION CENTER
on notification_Center(successCount, itemNum)
    set Plural_Test to (successCount) as number
    
    if Plural_Test is -1 then
        display notification "No Tabs Exported!" with title "Send Chrome Tabs to OmniFocus" subtitle "◸ Veritrope.com"
        
    else if Plural_Test is 0 then
        display notification "No Tabs Exported!" with title "Send Chrome Tabs to OmniFocus" subtitle "◸ Veritrope.com"
        
    else if Plural_Test is equal to 1 then
        display notification "Successfully Exported " & itemNum & ¬
            " Tab to OmniFocus" with title "Send Chrome Tabs to OmniFocus" subtitle "◸ Veritrope.com"
        
    else if Plural_Test is greater than 1 then
        display notification "Successfully Exported " & itemNum & ¬
            " Tabs to OmniFocus" with title "Send Chrome Tabs to OmniFocus" subtitle "◸ Veritrope.com"
    end if
    
    set itemNum to "0"
    delay 1
end notification_Center
