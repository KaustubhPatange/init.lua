local M = {}

local sys_util = require('util.sys')

local function OSMAP_TO_ECLIPSE(osmap)
  if osmap == sys_util.OSMAP.LINUX then
    return "linux"
  elseif osmap == sys_util.OSMAP.WINDOWS then
    return "win"
  elseif osmap == sys_util.OSMAP.MAC then
    return "mac"
  elseif osmap == sys_util.OSMAP.MAC_ARM then
    return "mac_arm"
  end
end

function M.should_setup(server_name)
  return server_name == "jdtls"
end

-- We use nvim-jdtls instead of lspconfig for Java.
-- This function will be called by mason when the filetype is `java`.
function M.setup()
  local osmap = sys_util.get_osmap()
  local eclipse_os = OSMAP_TO_ECLIPSE(osmap)
  local function attach_client()
    local root_markers = { 'gradlew', 'mvnw', '.git' }
    local root_dir = require('jdtls.setup').find_root(root_markers)

    local workspace_dir = root_dir or vim.fn.getcwd() .. "/.nvim"

    if vim.fn.isdirectory(workspace_dir) == 0 then
      vim.fn.mkdir(workspace_dir, "p")
    end

    local home_dir = vim.loop.os_homedir()

    local config = {
      root_dir = root_dir,
      cmd = {
        home_dir .. "/.local/share/java/amazon-corretto-21.jdk/Contents/Home/bin/java",
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        -- "-javaagent:~/.local/share/java/lombok.jar",
        -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        -- '-noverify',
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        home_dir .. "/.local/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version

        "-configuration",
        home_dir .. "/.local/share/java/jdtls/config_" .. eclipse_os,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.
        "-data",
        workspace_dir,
      },
      settings = { java = {} }
    }
    require("jdtls").start_or_attach(config)

    -- Mappings for Java
    nnoremap("<leader>lo", require("jdtls").organize_imports, "Organize imports")
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = attach_client,
  })
end

return M
