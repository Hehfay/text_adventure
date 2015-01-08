require 'curses'

in_file = 'title.txt'
fp = File.open(in_file, 'r')

Curses.init_screen
Curses.noecho
Curses.curs_set(0)

title = Curses::Window.new(0, 0, 0, 0)

my_string = ""
fp.each_line do |line|
  my_string << line
end
fp.close

title.addstr(my_string)
title.box('|', '-')
title.refresh
title.getch
title.close
