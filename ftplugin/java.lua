-- JDTLS (Java LSP) configuration
local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.env.HOME .. "/.jdtls-workspace/" .. project_name

-- Needed for debugging
local bundles = {
    vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
}

-- Needed for running/debugging unit tests
vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/java-test/*.jar", 1), "\n")
)

local home
local runtimes
local config
if vim.fn.has("macunix") == 1 then
    home = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
    runtimes = {
        {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home",
        },
        {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
        },
        {
            name = "JavaSE-21",
            path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
        },
    }
    config = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_macos"
else
    home = "/usr/lib/jvm/default"
    runtimes = {
        {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk",
        },
        {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk",
        },
        {
            name = "JavaSE-21",
            path = "/usr/lib/jvm/java-21-openjdk",
        },
    }
    config = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux"
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar",
        "-Xmx4g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- Eclipse jdtls location
        "-jar",
        vim.fn.stdpath("data") .. "/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
        -- TODO Update this to point to the correct jdtls subdirectory for your OS (config_linux, config_mac, config_win, etc)
        "-configuration",
        config,
        "-data",
        workspace_dir,
    },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    settings = {
        java = {
            -- TODO Replace this with the absolute path to your main java version (JDK 17 or higher)
            home = home,
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = runtimes,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            signatureHelp = { enabled = true },
            format = {
                enabled = true,
            },
        },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org",
            },
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },
    -- Needed for auto-completion with method signatures and placeholders
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    flags = {
        allow_incremental_sync = true,
    },
    init_options = {
        -- References the bundles defined above to support Debugging and Unit Testing
        bundles = bundles,
    },
}

-- Needed for debugging
config["on_attach"] = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
