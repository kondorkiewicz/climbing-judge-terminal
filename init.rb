#### Climbing Judge ####
#
# Lauch this ruby file from command line
# to get started.
#

APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'judge'

judge = Judge.new 
judge.start!