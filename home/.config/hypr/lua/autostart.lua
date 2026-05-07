--  Autostart necessary processes (like notifications daemons, status bars, etc.)
--  Or execute your favorite apps at launch like this:
local programs = require("programs")

hl.on("hyprland.start", function()
  for _, program in ipairs(programs.autostart) do
    hl.dsp.exec_cmd(program)
  end
end)
