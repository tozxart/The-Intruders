local TurtleNotifications = loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Notifications/main/source.lua"))()

local NotificationLibrary = TurtleNotifications.new(false, 2)

NotificationLibrary:QueueNotification(20, "Update Link!", "Get your free key here: https://go.click.ly/Jxeyd. For more info, join our Discord!", "Cancel-Copy", {
    Cancel = function()
        print("User chose to ignore the notification.")
    end,
    Copy = function()
        print("User clicked to copy the free key link.")
        setclipboard("https://go.click.ly/Jxeyd")
        print("Free key link copied to clipboard.")
    end
})
NotificationLibrary:SetNotificationDelay(20)
