-- Rock Neurotiko's rc.lua
-- that code it's GNU.GPL-v3
-- if you have some question, suggestion, or just wanna talk
-- here it's my email: miguelglafuente@gmail.com

-- P.D: Use emacs with lua-mode to edit the code, it will help you a lot!!! :)


-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widget Lib
require("vicious")
-- Load Debian menu entries
require("debian.menu")


-- useful for debugging, marks the beginning of rc.lua exec
-- awful.util.spawn_with_shell("echo Funciona_rc.lua | xmessage -timeout 10 -file -")


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/rock/.config/awesome/themes/zenburn/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "chromium-browser"


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
modkey = "Mod4"
-- }}}


--awful.util.spawn_with_shell("echo Funciona_tags | xmessage -timeout 10 -file -")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,            --1
    awful.layout.suit.tile.left,       --2
    awful.layout.suit.tile.bottom,     --3
    awful.layout.suit.tile.top,        --4
    awful.layout.suit.fair,            --5
    awful.layout.suit.fair.horizontal, --6
    awful.layout.suit.spiral,          --7
    awful.layout.suit.spiral.dwindle,  --8
    awful.layout.suit.max,             --9
    awful.layout.suit.max.fullscreen,  --10
    awful.layout.suit.magnifier,       --11
    awful.layout.suit.floating         --12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- I have this tags cause that's what I use everyday, and maybe it will change :P
--So, feel free to change it, but remember, the same names than layouts, and
--after remember to erase the rules, and make news if you want it :)
tags = {
  names = { "Mail", "Web", "Terms", "Media","Spotify", "emacs", "Downs", "Pdf's", 9},
  layout = {
    layouts[1], layouts[1], layouts[5],
    layouts[5], layouts[1], layouts[1],
    layouts[1], layouts[1], layouts[12],
  }}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "Mail", "Web", "Terms", "Media", "Spotify", "emacs", "Downs", "Pdf's", 9 }, s, layouts[1])
end
-- }}}

--AQUI

-- {{{ Menu
-- Create a laucher widget and a main menu
--The own menu who comes with awesome :P
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

--My menu :)
myrockmenu = {
   { "GnomeTerm", "gnome-terminal" },
   { "AlsaMixer", "alsamixergui" },
   { "Chrome", "chromium-browser" },
   { "VLC", "vlc" },
   { "Wicd", "wicd-client"},
   { "Spotify", "spotify"},
   { "Guake", "guake"}
}

mymainmenu = awful.menu({ items = { { "Rock", myrockmenu, beautiful.awesome_icon }, -- My menu.
                                    { "awesome", myawesomemenu, beautiful.awesome_icon }, --Awesome menu.
				    { "Menu", debian.menu.Debian_menu.Debian } --Debian menu.
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- Separators

--Two separators to make more beautifull the final interface :)
spacer    = widget({ type = "textbox" })
separator = widget({ type = "textbox" })
spacer.text     = " "
separator.text  = "|"

-- {{{ Wibox



-- Create a netwidget (usage)

--Widget who print the kb/s you are downloading and uploading :)
--Just with wlan, with eht you will have to change it ;)
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image("/home/rock/.config/awesome/icons/down.png")
upicon.image = image("/home/rock/.config/awesome/icons/up.png")
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, "${wlan0 down_kb}kb/s / ${wlan0 up_kb}kb/s", 1)



-- Create a batwidget (status chrg%)

baticon = widget({ type = "imagebox" })
baticon.image = image("/home/rock/.config/awesome/icons/bat.png")
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
--Displays a plus or minus (charging or not){$1}, then the percentage of charge {$2}, and at the end 
--the time to finish the charge or discharge {$3}.
--Maybe you will have to change the BAT0 for BAT1, or BAT2... Try :)
vicious.register(batwidget, vicious.widgets.bat, "$1_$2% - $3", 30, "BAT0")



-- That's a Widget to know the MB used and total, but I have a netbook, and I don't use it
--(that's a really little screen), fell free to ucomment it, and use then in the Wibox
--(name of icon: memicon, name of widget: memwidget)

-- Create a memwidget (usage$ usedMB/TotalMB)
--memicon = widget({ type = "imagebox" })
--memicon.image = image("/home/rock/.config/awesome/icons/mem.png")
-- Initialize widget
--memwidget = widget({ type = "textbox" })
-- Register widget
--vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB)", 13)


-- Create a cpuwidget (usage%)

-- A widget who displays the percentage of CPU usage :)
-- The vicious.widgets.cpu return three variables, $1 is the percentage total usage.
-- $2 is the percentage of the first CPU usage, and $3 is the percentage of the second CPU usage.
-- I just use the first one, you can put all you want.
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image("/home/rock/.config/awesome/icons/cpu.png")
-- Initialize widget
cpuwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%", 2)



-- Create a wifiwidget
 
-- Wifi widget!!!!
-- It displays the SSID of the net you are connected ( ${ssid} ), the percentage of connectivity ( ${link} )
-- and the rate ( ${rate} )
wifiicon = widget({ type = "imagebox" })
wifiicon.image = image("/home/rock/.config/awesome/icons/wifi.png")
-- Initialize widget
wifiwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid} ${link}% ${rate}", 5, "wlan0") 

wifiwidget:buttons(awful.util.table.join(
		      awful.button({}, 1, function() awful.util.spawn("wicd-client", true) end) --Left click to open wicd-client, but becarefull to don't open it twice or more
					))





--My volume widget
volumeicon = widget({ type = "imagebox" })
volumeicon.image = image("/home/rock/.config/awesome/icons/vol.png")
volumewidget = widget({ type = "textbox" })
vicious.register(volumewidget, vicious.widgets.volume, "$1% -- Mut: $2 ", 1, "Master")

volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("xterm -e alsamixergui", true) end),                --Left click to open alsamixer in a xterm
    awful.button({ }, 3, function () awful.util.spawn("amixer -q set Master toggle", false) end)    --Right click to mute/umute (I have the keybind modkey+F11 to do it too)
					  ))

--To volume_up and Volume_down I have two keybindings: modkey+F10 to up and modkey+F9 to down it.




-- Create a textclock widget

-- Just a clock widget :)
clockicon = widget({ type = "imagebox" })
clockicon.image = image("/home/rock/.config/awesome/icons/time.png")
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = 14, screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s], 
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s], separator,  --Layout icon, to change it clicking.
        mytextclock, spacer, clockicon, separator, --the clock!
        batwidget, spacer, baticon, separator, --Battery widget :)
        upicon, netwidget, dnicon, separator, --up/down-load kb/s widget
        wifiwidget, spacer, wifiicon, separator, --Wifi widget
        cpuwidget, spacer, cpuicon, separator,  --CPU usage widget
	volumewidget, spacer, volumeicon,  separator, --Volume widget
        s == 1 and mysystray or nil, separator,  --(systray) {taskbar}
        mytasklist[s], separator,  --applications open.
        layout = awful.widget.layout.horizontal.rightleft --layouts :)

	--Check out that it's ordered right-to-left.
	--everyline it's one "space" in our bar
	-- I use the widgets "spacer" and "separator" to space the widget with his icon
	-- and the separator to print a line and separate (Mr.Obviusly!) the widgets :)
    }
end
-- }}}


-- awful.util.spawn_with_shell("echo Funciona_bindings | xmessage -timeout 10 -file -")
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

   --To use this modkey you need to have installed xlock.
   --This keybinding blocks the screen with xlock. (push Mod4+b)
   awful.key({modkey, }, "b", function() awful.util.spawn("xlock") end),
   
   --This keybinding prints a message with the calendar of the actual month 
   awful.key({ modkey }, "F1", function () awful.util.spawn_with_shell("cal -h | xmessage -timeout 10 -file -") end),

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    --Volume!!

    awful.key({modkey,            }, "F9", function () awful.util.spawn("amixer -q sset Master 10%-") end),
    awful.key({modkey,            }, "F10", function () awful.util.spawn("amixer -q sset Master 10%+") end),
    awful.key({modkey,            }, "F7",        function () awful.util.spawn("mpc stop") end),
    awful.key({modkey,            }, "XF86AudioPlay",        function () awful.util.spawn("mpc toggle") end),
    awful.key({modkey,            }, "F8",        function () awful.util.spawn("mpc next") end),
    awful.key({modkey,            }, "F6",        function () awful.util.spawn("mpc prev") end),
    awful.key({modkey             }, "F11",        function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({ modkey,           }, "m",                    function () awful.util.spawn(terminal .. " -e ncmpcpp") end),
	


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
				  )				  


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end


clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))



-- Set keys
root.keys(globalkeys)

--My own rules to tags :)
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },

    {rule = { class = "Gnome-terminal"},
     properties = { tag = tags[1][3], switchtotag=true}},

    { rule = { class = "Firefox"},
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = { class = "Chromium"},
      properties = { tag = tags[1][2], switchtotag = true } },

    { rule = {class = "Spotify"},
      properties = { tag = tags[1][5], switchtotag= true}},

    { rule = { class = "Emacs" },
      properties = { tag = tags[1][6], switchtotag = true } },

    { rule = { class = "gimp" },
      properties = { tag = tags[1][4], switchtotag = true , floating = true} },

    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][1], switchtotag = true } },

    { rule = { class = "Evince"},
      properties = { tag = tags [1][8], switchtotag=true}},
    
    { rule = { class = "Vlc"},
      properties = { tag = tags[1][4], switchtotag=true}},

    { rule = { class = "Ktorrent"},
      properties = { tag = tags[1][7], switchtotag=true}},


}

-- }}}

 


-- {{{
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart my personal stuffs




--CONFIGURATION FILES REQUIRED

--require("bindings")
--require("tags")



awful.util.spawn_with_shell("xautolock -time 10 &")