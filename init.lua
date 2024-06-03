local get_state_attr = ya.sync(function(state, attr)
  return state[attr]
end)

return {
  setup = function(state, options)
    options = options or {}
    if options.shell ~= nil then
      state.shell = options.shell
    else
      state.shell = ya.target_family() == "windows" and os.getenv("ComSpec") or os.getenv("SHELL")
      state.shell = '"' .. state.shell .. '"'
    end
  end,
  entry = function(self, args)
    local shell = ""
    if #args > 0 then
      shell = table.concat(args, " ")
    else
      shell = get_state_attr("shell")
    end
    ya.manager_emit("shell", { shell, block = true, confirm = true })
  end
}
