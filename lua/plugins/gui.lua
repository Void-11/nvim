return {
  -- Process management and GUI app launching
  {
    "nvim-lua/plenary.nvim",
    config = function()
      _G.GUI = _G.GUI or {}
      GUI.running_processes = GUI.running_processes or {}

      function GUI.launch(cmd, args, opts)
        opts = opts or {}
        local full = cmd
        if args and #args > 0 then full = cmd .. " " .. table.concat(args, " ") end
        local job_id = vim.fn.jobstart(full, {
          detach = opts.detach ~= false,
          cwd = opts.cwd or vim.fn.getcwd(),
          on_exit = function(id, code, evt)
            GUI.running_processes[id] = nil
            if opts.on_exit then opts.on_exit(id, code, evt) end
          end,
        })
        if job_id > 0 then
          GUI.running_processes[job_id] = { cmd = full, pid = job_id, start_time = os.time(), opts = opts }
          vim.notify("Launched: " .. full, vim.log.levels.INFO)
        else
          vim.notify("Failed to launch: " .. full, vim.log.levels.ERROR)
        end
        return job_id
      end

      function GUI.kill(id)
        if GUI.running_processes[id] then vim.fn.jobstop(id); GUI.running_processes[id] = nil; return true end
        return false
      end

      function GUI.kill_all()
        for id, _ in pairs(GUI.running_processes) do vim.fn.jobstop(id) end
        GUI.running_processes = {}
        vim.notify("Killed all processes", vim.log.levels.INFO)
      end

      vim.keymap.set('n', '<leader>gk', GUI.kill_all, { desc = "GUI: Kill All" })
    end,
  },
}

