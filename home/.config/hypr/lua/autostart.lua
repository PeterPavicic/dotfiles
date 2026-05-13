--  Autostart necessary processes (like notifications daemons, status bars, etc.)
--  Or execute your favorite apps at launch like this:
local programs = require("lua.programs")

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm finalize")
  for _, program in ipairs(programs.autostart) do
    hl.exec_cmd(program)
  end
end)
