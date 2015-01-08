class Game_Window

  require 'curses'

  MAX_X = 189
  MAX_Y = 47

  def draw_display

    Curses.init_screen
    Curses.noecho
    Curses.curs_set(0)


    display = Curses::Window.new(0, 30, 0, 0)
    control = Curses::Window.new(13, 158, 47 - 13, 31)

    display.box('|', '-')
    display.refresh
    
    control.box('|', '-')
    control.refresh

    control.getch

    display.close
    control.close
  end

end

main_window = Game_Window.new

main_window.draw_display
