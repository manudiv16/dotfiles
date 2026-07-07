local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.exec("/opt/homebrew/bin/aerospace list-monitors", function(monitors_output)
  for line in monitors_output:gmatch("[^\r\n]+") do
    local monitor_id = line:match("^(%d+)")
    if monitor_id then
      local mid = tonumber(monitor_id)

      sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --monitor " .. monitor_id, function(spaces_output)
        for space_name in spaces_output:gmatch("[^\r\n]+") do
          local space = sbar.add("item", "space." .. space_name, {
            display = mid,
            icon = {
              font = { family = settings.font.numbers },
              string = space_name,
              padding_left = 15,
              padding_right = 8,
              color = colors.white,
              highlight_color = colors.yellow,
            },
            label = {
              padding_right = 20,
              color = colors.white,
              highlight_color = colors.yellow,
              font = "sketchybar-app-font:Regular:16.0",
              y_offset = -1,
            },
            padding_right = 1,
            padding_left = 1,
            background = {
              color = colors.bg1,
              border_width = 1,
              height = 26,
              border_color = colors.yellow,
            },
            click_script = "/opt/homebrew/bin/aerospace workspace " .. space_name,
          })

          -- Double border effect per space item
          local space_bracket = sbar.add("bracket", "space.bracket." .. space_name, { space.name }, {
            background = {
              color = colors.white,
              border_color = colors.white,
              height = 28,
              border_width = 2,
            },
            display = mid,
          })

          sbar.add("item", "space.padding." .. space_name, {
            display = mid,
            width = settings.group_paddings,
            background = { drawing = false },
            label = { drawing = false },
            icon = { drawing = false },
          })

          local function set_focused(selected)
            space:set({
              icon = { highlight = selected },
              label = { highlight = selected },
              background = { border_color = selected and colors.white or colors.yellow },
            })
            space_bracket:set({
              background = { border_color = selected and colors.yellow or colors.white },
            })
          end

          local function update_windows()
            sbar.exec(
              "/opt/homebrew/bin/aerospace list-windows --workspace " .. space_name,
              function(windows)
                local icon_line = ""
                local no_app = true
                for win_line in windows:gmatch("[^\r\n]+") do
                  local app = win_line:match("^%d+%s*|%s*(.-)%s*|")
                  if app and app ~= "" then
                    no_app = false
                    local lookup = app_icons[app]
                    local icon = (lookup == nil) and app_icons["default"] or lookup
                    icon_line = icon_line .. " " .. icon
                  end
                end
                sbar.animate("tanh", 10, function()
                  space:set({ label = no_app and " —" or icon_line })
                end)
              end
            )
          end

          space:subscribe("aerospace_workspace_change", function(env)
            local selected = env.FOCUSED_WORKSPACE == space_name
            set_focused(selected)
            update_windows()
          end)

          space:subscribe("aerospace_focus_change", function()
            update_windows()
          end)

          space:subscribe("space_windows_change", function()
            update_windows()
          end)

          -- Estado inicial
          sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(focused)
            local ws = focused:gsub("[%s\n\r]+", "")
            set_focused(ws == space_name)
            update_windows()
          end)
        end
      end)
    end
  end
end)

local spaces_indicator = sbar.add("item", "spaces_indicator", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.white,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.black,
  },
  background = {
    color = colors.with_alpha(colors.transparent, 0.0),
    border_color = colors.with_alpha(colors.transparent, 0.0),
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.entered", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function()
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger("swap_menus_and_spaces")
end)
