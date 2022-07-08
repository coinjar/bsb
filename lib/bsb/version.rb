# frozen_string_literal: true

module BSB
  VERSION = File.read(File.join(File.dirname(__FILE__), '.current-version')).strip
end
