-- Configurar jdtls para usar Java 21 específicamente
-- Este archivo se ejecuta automáticamente cuando abres un archivo .java

-- Establecer JAVA_HOME para jdtls
vim.env.JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/21.0.9-tem")
