/***********/
/* Include */
/***********/
#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
/**********/
/* Define */
/**********/
#define RED "\x1b[31m"
#define RESET "\x1b[0m"
#define CORRECT_ARGC 2
#define MESSAGE1 "Initial Condition:\n"
#define MESSAGE2 "(Press any key to continue)\n"
//#define DEBUG
#define INVISIBLE 0
#define NORMAL 1
#define VERY_VISIBLE 2
/*************/
/* Functions */
/*************/
void display(int** x, int rows, int columns);
void get_x2d(int** x, int* x1d, int rows, int columns);
void init(int** x, int rows, int columns);
void argc_check(int* argc, int correct_argc);
void press_any_key();
void title_screen();
void get_input(int** d, int max_y, int max_x); /* TODO return void? */
/********/
/* Main */
/********/
int main(int argc, char** argv)
{
  initscr();
  cbreak();
  noecho();
  intrflush(stdscr, FALSE);
  keypad(stdscr, true);
  curs_set(VERY_VISIBLE);
  argc_check(&argc, CORRECT_ARGC);

  /* [rows][columns] */
  int*  d1d;
  int*  dnext1d;
  int** dnext;
  int** d;
  int** dtemp;
  int rows;
  int columns;
  int max_y;
  int max_x;

  getmaxyx(stdscr, max_y, max_x);
  rows = max_y + 2;
  columns = max_x + 2;
  d1d = (int*)calloc(rows*columns, sizeof(int));
  dnext1d = (int*)calloc(rows*columns, sizeof(int));
  dnext = (int**)malloc(rows*sizeof(int*));
  d = (int**)malloc(rows*sizeof(int*));
  get_x2d(d, d1d, rows, columns);
  get_x2d(dnext, dnext1d, rows, columns);
  init(d, rows, columns);
  init(dnext, rows, columns);

  title_screen();
  get_input(d, max_y, max_x);
  curs_set(INVISIBLE);

  move(0, 0);
  erase();
  printw(MESSAGE1);
  press_any_key();
  erase();
  display(d, rows, columns);
  getch();

#ifndef DEBUG
  int i, j, k;
  int sum;
  int t = atoi(argv[1]);
  for(k = 0; k < t; k++)
  {
    for(i = 1; i < rows-1; i++)
    {
      for(j = 1; j < columns-1; j++)
      {
        sum = d[i+1][j] + d[i-1][j] + d[i][j-1] + d[i][j+1] + d[i-1][j-1]
              + d[i-1][j+1] + d[i+1][j-1] + d[i+1][j+1];

        if(d[i][j])
        {
          switch(sum)
          {
            case 2:
            case 3:
              dnext[i][j] = 1;
              break;
            default:
              dnext[i][j] = 0;
          }
        }
        else
        {
          if(sum == 3)
          {
            dnext[i][j] = 1;
          }
          else
          {
            dnext[i][j] = 0;
          }
        }
      }
    }
    dtemp = d;
    d = dnext;
    dnext = dtemp;
    erase();
    display(d, rows, columns);
    getch();
  }
#endif
  free(d);
  free(dnext);
  free(dnext1d);
  free(d1d);
  endwin();
  return 0;
}
/***************/
/* Definitions */
/***************/
void display(int** x, int rows, int columns)
{
  int i, j;
  for(i = 1; i < rows-1; i++)
  {
    for(j = 1; j < columns-1; j++)
    {
      if(x[i][j])
      {
        printw("x");
      }
      else
      {
        printw(" ");
      }
    }
    printw("\n");
  }
  printw("\n");
}

void get_x2d(int** x, int* x1d, int rows, int columns)
{
  int i, j;
  for(i = 0, j = 0; i < rows; j += columns, i++)
  {
    x[i] = x1d + j;
  }
}

void init(int** x, int rows, int columns)
{
  int i, j;
  for(i = 0; i < rows; i++)
  {
    x[i][0] = 0;
    x[i][columns-1] = 0;
  }
  for(j = 0; j < columns; j++)
  {
    x[0][j] = 0;
    x[rows-1][j] = 0;
  }
  for(i = 1; i < rows-1; i++)
  {
    for(j = 1; j < columns-1; j++)
    {
      x[i][j] = 0;
    }
  }
}

void argc_check(int* argc, int correct_argc)
{
  if(*argc == correct_argc)
  {
    return;
  }
  else
  {
    const char *message1 = "Provide Number of Timesteps via command line.\n";
    addstr(message1);
    press_any_key();
    endwin();
    exit(1);
  }
}

void press_any_key()
{
  addstr(MESSAGE2);
  getch();
}

void title_screen()
{
#define COLUMNS 60
#define ROWS 15
  char title[ROWS][COLUMNS] = {
    "###########################################################\n",
    "                                                           \n",
    "#######  #   #  #####    #####      #      #       #  #####\n",
    "   #     #   #  #        #         # #     ##     ##  #    \n",
    "   #     #####  ###      #  ##    # # #    # #   # #  ###  \n",
    "   #     #   #  #        #   #   #     #   #  # #  #  #    \n",
    "   #     #   #  #####    #####  #       #  #   #   #  #####\n",
    "                                                           \n",
    "####### ######  #      #  ######  #####                    \n",
    "#     # #       #         #       #                        \n",
    "#     # ###     #      #  ###     ###                      \n",
    "#     # #       #      #  #       #                        \n",
    "####### #       #####  #  #       #####                    \n",
    "                                                           \n",
    "###########################################################\n"
  };

  const char* prompt0 = "Move with the arrow keys.\n";
  const char* prompt1 = "Press 'x' to create a cell.\n";
  const char* prompt2 = "Press 'd' to delete a cell.\n";
  const char* prompt3 = "Press enter when finished and to begin the simulation.\n";
  const char* prompt4 = "(Press enter to continue)\n";

  int i, j;
  for(i = 0; i < ROWS; i++)
  {
    for(j = 0; j < COLUMNS; j++)
    {
      addch(title[i][j]);
    }
  }
  addstr(prompt0);
  addstr(prompt1);
  addstr(prompt2);
  addstr(prompt3);
  addstr(prompt4);

  int input;
  input = wgetch(stdscr);
  while(input != '\n')
  {
    input = wgetch(stdscr);
  }
  erase();
}

void get_input(int** d, int max_y, int max_x)
{
  int input;
  int current_x;
  int current_y;

  current_x = 0;
  current_y = 0;

  input = wgetch(stdscr);
  while(input != '\n')
  {
    switch(input)
    {
      case KEY_LEFT:
        if(current_x > 0)
        {
          current_x--;
        }
        break;

      case KEY_RIGHT:
        if(current_x < max_x - 1)
        {
          current_x++;
        }
        break;

      case KEY_UP:
        if(current_y > 0)
        {
          current_y--;
        }
        break;

      case KEY_DOWN:
        if(current_y < (max_y - 1) / 2)
        {
          current_y++;
        }
        break;

      case 'x':
        delch();
        insch('x');
        d[current_y+1][current_x+1] = 1;
        break;

      case 'd':
        delch();
        insch(' ');
        d[current_y+1][current_x+1] = 0;
        break;

      default:
        flash();
    }
    wmove(stdscr, current_y, current_x);
    wrefresh(stdscr);
    input = wgetch(stdscr);
  }
}
