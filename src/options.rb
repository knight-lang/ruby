module Kn
  class Options
    def escapes_and_interpolation? = true
    def modulo_strings? = true
  end

  def self.options = $options
  $options = Options.new
end
