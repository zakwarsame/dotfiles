tell application (path to frontmost application as text)
    try
        set imageFile to (choose file with prompt "Select an image file:" of type "public.image") as text
    on error
        return "No file selected"
    end try
end tell

if imageFile is not "No file selected" then
    tell application "System Events"
        repeat with desktopIndex from 1 to count of desktops
            tell desktop desktopIndex
                set picture to imageFile
            end tell
        end repeat
    end tell
    return POSIX path of (imageFile as alias) -- Converts to POSIX path format for compatibility
else
    return "No file selected"
end if

