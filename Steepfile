D = Steep::Diagnostic

target :lib do
  signature "sig"

  check "lib"

  library "date", "json", "time" # Standard libraries
  # library "csv"
  library "fileutils"

  configure_code_diagnostics(D::Ruby.default) # `strict` diagnostics setting
  # configure_code_diagnostics(D::Ruby.lenient) # `lenient` diagnostics setting
  # configure_code_diagnostics(D::Ruby.strict) # `strict` diagnostics setting
  configure_code_diagnostics do |hash| # You can setup everything yourself
    hash[D::Ruby::UnsupportedSyntax] = :warning
    hash[D::Ruby::UnknownConstant] = :warning
  end
end

# target :test do
#   signature "sig", "sig-private"
#
#   check "test"
#
#   # library "pathname", "set"       # Standard libraries
# end
