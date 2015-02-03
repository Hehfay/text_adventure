#!/usr/bin/env ruby

class Game_Window

  require 'curses'
  include Curses

  HEIGHT_OF_CONTROL = 0.33 # 1/3 of the screen

  def Game_Window.get_max_xy 
    window = Curses::Window.new(0, 0, 0, 0)
    @@x = window.maxx
    @@y = window.maxy
    @@control_size = @@y * HEIGHT_OF_CONTROL
    window.close
  end

  def Game_Window.draw_display
    display ||= Curses::Window.new(@@y - @@control_size, 0, 0, 0)
    display.box('|', '-')
    display.refresh
    return display
  end

  def Game_Window.draw_control
    control ||= Curses::Window.new(@@control_size, 0, (@@y - @@control_size), 0)
    control.box('|', '-')
    control.refresh
    return control
  end

  def Game_Window.populate_screen(window)
    window.setpos(2, (@@x * 0.20))
    window.addstr('Option 1' || A_PROTECTED)
    window.setpos(2, (@@x * 0.60))
    window.addstr('Option 2' || A_PROTECTED)
    window.refresh
  end

  def Game_Window.close(window)
    window.clear
    window.refresh
    window.close
  end

  def Game_Window.move_cursor(window)
    window.setpos(2, (@@x * 0.20) - 1)
    window.insch('>')
    window.refresh
    input = window.getch
    until input == Curses::KEY_UP  
      case 
      when input == Curses::KEY_BACKSPACE
        Curses.flash
      when input == Curses::KEY_DOWN
        Curses.flash
      when input == Curses::KEY_LEFT
        window.delch
        window.insch(' ')
        window.setpos(2, (@@x * 0.20) - 1)
        window.delch
        window.insch('>')
        window.refresh
      when input == Curses::KEY_RIGHT
        window.delch
        window.insch(' ')
        window.setpos(2, (@@x * 0.60) - 1)
        window.delch
        window.insch('>')
        window.refresh
      else
        Curses.flash
      end
      input = window.getch
    end
  end

  def set_term_mode
    Curses.cbreak
    Curses.curs_set(0)
    @control.keypad(true)
    @control.setpos(2, (@x * 0.20) - 1 )
  end

end

Curses.init_screen
Curses.noecho
Curses.curs_set(2)
Game_Window.get_max_xy

control = Game_Window.draw_control
display = Game_Window.draw_display

control.keypad(true)
display.keypad(false)

Game_Window.populate_screen(control)
Game_Window.move_cursor(control)

Game_Window.close(display)
Game_Window.close(control)
Curses.close_screen

