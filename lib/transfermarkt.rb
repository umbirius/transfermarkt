require 'open-uri'
require 'nokogiri'
require 'terminal-table'
require 'tty-prompt'
require "colorize"

require_relative "./transfermarkt/version"
require_relative "./transfermarkt/player"
require_relative "./transfermarkt/scraper"
require_relative './transfermarkt/cli'