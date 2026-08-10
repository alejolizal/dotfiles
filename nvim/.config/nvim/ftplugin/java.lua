-- Configurar jdtls para usar Java 25 (runtime del LSP)
-- JDK 25 puede analizar código de versiones anteriores (17, 21, 25) sin problema,
-- así que este setting sirve para los tres módulos del repo.

vim.env.JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/25.0.2-tem")
