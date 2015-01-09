class Game_Window

  require 'curses'
  include Curses

  HEIGHT_OF_BOTTOM_BOX = 0.33 

  def get_max_xy 
    Curses.init_screen
    window = Curses::Window.new(0, 0, 0, 0)
    x = window.maxx
    y = window.maxy
    array = [x, y]
    window.close
    return array
  end

  def draw_display(array)
    @x = array[0]
    @y = array[1]
    Curses.init_screen
    Curses.noecho
    Curses.curs_set(1)

    @control = Curses::Window.new( (@y * HEIGHT_OF_BOTTOM_BOX), 0, (@y - (@y * HEIGHT_OF_BOTTOM_BOX) + 1), 0 )
    @control.box('|', '-')
    @control.refresh
  end

  def populate_screen
    @control.setpos(2, (@x * 0.20))
    @control.addstr('Option 1')
    @control.setpos(2, (@x * 0.40))
    @control.addstr('Option 2')
    @control.setpos(2, (@x * 0.60))
    @control.addstr('Option 3')
  end

  def on_close
    @control.close
  end

  def move_cursor
    Curses.cbreak
    Curses.curs_set(0)
    @control.keypad(true)
    @control.setpos(2, (@x * 0.20) - 1 )
    input = @control.getch
    until input == Curses::KEY_UP  
      case 
      when input == Curses::KEY_BACKSPACE
        Curses.flash
      when input == Curses::KEY_DOWN
        Curses.flash
      when input == Curses::KEY_LEFT
        @control.delch
        @control.setpos(2, (@x * 0.20) - 1)
        @control.insch('>')
        @control.refresh
      when input == Curses::KEY_RIGHT
        @control.delch
        @control.setpos(2, (@x * 0.60) - 1)
        @control.insch('>')
        @control.refresh
      else
        Curses.flash
      end
      input = @control.getch
    end
  end

end

main_window = Game_Window.new
main_window.draw_display(main_window.get_max_xy)
main_window.populate_screen
main_window.move_cursor
main_window.on_close
