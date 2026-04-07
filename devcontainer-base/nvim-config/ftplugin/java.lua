-- Configurar jdtls para usar Java 21 específicamente
-- Este archivo se ejecuta automáticamente cuando abres un archivo .java
-- Adaptado para devcontainer: resolución dinámica de ruta Java 21

local java21_path = vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java/21*-tem"))
if java21_path ~= "" then
  vim.env.JAVA_HOME = java21_path
end
