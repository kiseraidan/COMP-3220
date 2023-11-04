#
# Author: Aidan Kiser (ark0053)
# Version: 3 November 2023
#

load "TinyParser.rb"
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

parse = Parser.new("input3.tiny")
mytree = parse.program()
puts mytree.toStringList()
