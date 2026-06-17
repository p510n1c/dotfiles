local function get_jdtls()
  local base = "/home/cybershadow/.local/share/nvim/mason/packages/jdtls"

  local launcher_list = vim.fn.glob(base .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)

  local launcher = nil
  if type(launcher_list) == "table" then
    launcher = launcher_list[1]
  elseif launcher_list ~= "" then
    launcher = launcher_list
  end

  local SYSTEM = "linux"
  local config = base .. "/config_" .. SYSTEM

  local lombok = "/home/cybershadow/.local/share/java/lombok.jar"

  return launcher, config, lombok
end
local function get_bundles()
  local bundles = {}

  local debug_adapter = vim.fn.glob(
    "/home/cybershadow/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true,
    true
  )

  if type(debug_adapter) == "table" then
    vim.list_extend(bundles, debug_adapter)
  elseif debug_adapter ~= "" then
    table.insert(bundles, debug_adapter)
  end

  local test_bundles =
    vim.fn.glob("/home/cybershadow/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", true, true)

  if type(test_bundles) == "table" then
    vim.list_extend(bundles, test_bundles)
  elseif test_bundles ~= "" then
    vim.list_extend(bundles, vim.split(test_bundles, "\n"))
  end

  return bundles
end

local function get_workspace()
  local workspace_path = "/home/cybershadow/.code/workspace/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  return workspace_path .. project_name
end

local function setup_jdtls()
  local jdtls = require("jdtls")

  local launcher, os_config, lombok = get_jdtls()

  if not launcher then
    vim.notify("❌ JDTLS launcher not found. Check Mason installation.", vim.log.levels.ERROR)
    return
  end

  local workspace_dir = get_workspace()

  local bundles = get_bundles()

  local root_dir = jdtls.setup.find_root({
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    ".git",
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local base_capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.workspace = base_capabilities.workspace
  capabilities.workspace.configuration = true
  capabilities.workspace.didChangeWorkspaceFolders = {
    dynamicRegistration = true,
  }

  capabilities.textDocument.completion.snippetSupport = false

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-javaagent:" .. lombok,

    "-jar",
    launcher,

    "-configuration",
    os_config,

    "-data",
    workspace_dir,
  }

  local settings = {
    java = {
      format = {
        enabled = false,
      },
      eclipse = {
        downloadSource = true,
      },
      maven = {
        downloadSources = true,
      },
      signatureHelp = {
        enabled = true,
      },
      contentProvider = {
        preferred = "fernflower",
      },
      saveActions = {
        organizeImports = true,
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "java",
          "jakarta",
          "javax",
          "com",
          "org",
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      referencesCodeLens = {
        enabled = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  }

  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  local on_attach = function(_, bufnr)
    require("jdtls.dap").setup_dap()
    require("jdtls.dap").setup_dap_main_class_configs()
    require("jdtls.setup").add_commands()

    vim.lsp.codelens.refresh()

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.java" },
      callback = function()
        pcall(vim.lsp.codelens.refresh)
      end,
    })
  end

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    capabilities = capabilities,
    init_options = init_options,
    on_attach = on_attach,
  }

  jdtls.start_or_attach(config)
end

return {
  setup_jdtls = setup_jdtls,
}
