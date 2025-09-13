return {
  -- UE5 utilities and keymaps
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Expose UE5 helpers namespace
      _G.UE5 = _G.UE5 or {}

      local is_win = (vim.fn.has("win32") == 1)
      local is_mac = (vim.fn.has("mac") == 1)
      local is_lin = (vim.fn.has("unix") == 1) and not is_mac

      function UE5.get_project_info()
        if not (_G.is_ue5_project and _G.is_ue5_project()) then return nil end
        local file = vim.g.ue5_project_file
        if not file then return nil end
        local name = vim.fn.fnamemodify(file, ":t:r")
        local engine_path = vim.g.ue5_engine_path
        return { name = name, file = file, root = vim.g.ue5_project_root, engine_path = engine_path }
      end

      local function editor_path(engine)
        if is_win then return engine .. "\\Engine\\Binaries\\Win64\\UnrealEditor.exe" end
        if is_mac then return engine .. "/Engine/Binaries/Mac/UnrealEditor.app/Contents/MacOS/UnrealEditor" end
        if is_lin then return engine .. "/Engine/Binaries/Linux/UnrealEditor" end
        return nil
      end

      function UE5.launch_editor()
        local info = UE5.get_project_info()
        if not info then return vim.notify("Not in a UE5 project", vim.log.levels.ERROR) end
        local editor = editor_path(info.engine_path)
        if not editor then return vim.notify("UE5 editor path not resolved", vim.log.levels.ERROR) end
        local cmd
        if is_win then
          cmd = string.format('"%s" "%s"', editor, info.file)
        else
          cmd = string.format('"%s" "%s"', editor, info.file)
        end
        vim.fn.jobstart(cmd, { detach = true, cwd = info.root })
        vim.notify("Launching UE5 Editor...", vim.log.levels.INFO)
      end

      local function build_cmd(engine, name, platform, config)
        if is_win then
          return string.format('"%s\\Engine\\Build\\BatchFiles\\Build.bat" %s %s %s', engine, name, platform, config)
        else
          local os_tag = is_mac and "Mac" or "Linux"
          return string.format('"%s/Engine/Build/BatchFiles/%s/Build.sh" %s %s %s', engine, os_tag, name, platform, config)
        end
      end

      function UE5.build(config)
        local info = UE5.get_project_info(); if not info then return end
        config = config or "Development"
        local platform = is_mac and "Mac" or (is_lin and "Linux" or "Win64")
        local cmd = build_cmd(info.engine_path, info.name, platform, config)
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({ cmd = cmd, dir = info.root, direction = "horizontal", close_on_exit = false }):open()
      end

      local function uat_cmd(engine, proj, platform, config, outdir)
        if is_win then
          return string.format('"%s\\Engine\\Build\\BatchFiles\\RunUAT.bat" BuildCookRun -project="%s" -platform=%s -configuration=%s -cook -stage -package -archive -archivedirectory="%s"', engine, proj, platform, config, outdir)
        else
          return string.format('"%s/Engine/Build/BatchFiles/RunUAT.sh" BuildCookRun -project="%s" -platform=%s -configuration=%s -cook -stage -package -archive -archivedirectory="%s"', engine, proj, platform, config, outdir)
        end
      end

      function UE5.package(platform, config)
        local info = UE5.get_project_info(); if not info then return end
        platform = platform or (is_mac and "Mac" or (is_lin and "Linux" or "Win64"))
        config = config or "Shipping"
        local outdir = info.root .. (is_win and "\\Packaged\\" or "/Packaged/") .. platform
        local cmd = uat_cmd(info.engine_path, info.file, platform, config, outdir)
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({ cmd = cmd, dir = info.root, direction = "horizontal", close_on_exit = false }):open()
      end

      if _G.is_ue5_project and _G.is_ue5_project() then
        vim.keymap.set('n', '<leader>ule', UE5.launch_editor, { desc = "UE5: Launch Editor" })
        vim.keymap.set('n', '<leader>ubd', function() UE5.build("Development") end, { desc = "UE5: Build Dev" })
        local default_platform = is_mac and "Mac" or (is_lin and "Linux" or "Win64")
        vim.keymap.set('n', '<leader>upm', function() UE5.package(default_platform, "Shipping") end, { desc = "UE5: Package" })
      end

      -- Auto-detect compile_commands.json for UE5
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if _G.is_ue5_project and _G.is_ue5_project() then
            local path = vim.g.ue5_project_root .. (is_win and "\\compile_commands.json" or "/compile_commands.json")
            if vim.fn.filereadable(path) == 0 then
              vim.notify("Consider generating compile_commands.json (UE5)", vim.log.levels.INFO)
            end
          end
        end,
      })
    end,
  },
}

