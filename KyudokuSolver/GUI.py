# Copyright © 2019 Jake Gonzalez. All rights reserved.
# Python graphical user interface for Answer Set Programming Kyudoku solver
# by Jake Gonzalez
# Department of Computer Science
# Texas Tech University
# email: Jake.Gonzalez@ttu.edu
# Last updated: 6/20/19
#
# This program is a graphical user interface for a Kyudoku puzzle solver written in Answer Set Programming. Upon running the program,
# a GUI interface is displayed with a 6 x 6 bland Kyudoku board with a place to input the initial starting selected square using the X,Y 
# coordinates. The user inputs the numbers in each of the 36 black entry boxes that correspond with a given puzzle to solve. After all 36
# entry boxes are filled with the correct numbers, and the correct X,Y coordinates for the inital selection is input, the solve button is
# clicked to create a file with the informaion that is then sent to clingo to get the answer set. The output from clingo is fed to 
# mkatoms to format the output in an easy to use format. The file output from mkatoms is then read, and the GUI displays the solution 
# for the given puzzle (given all information was input correctly, and there is a possible solution).
#
# There are three buttons on the GUI, 'Clear', 'Instructions', and 'Solve'. The 'Clear' button clears the board of any inputs. The 
# 'Instructions' button opens another window which displays the rules for the Kyudoku puzzle. The 'Solve' button calls the funcion to create 
# the input file and calls clingo and mkatoms. 
#
# Note: This program requires Python 3.7 or later and requires Clingo and Mkatoms be installed and in the user's system path. The program file 
# Kyudokuforpy.txt must be in the path or in the same directory as this program. This program creates two files when running, tempKyu.txt and kyuout.txt. 
# These files are not deleted after the program runs. 

from tkinter import *
from os import system

class KyudokuGUI:

    def __init__(self):
        # This funcion is used to initialte the GUI. A window is brought up and graphics are rendered. mainloop() allows
        # the funcion to display the GUI, add inputs, and wait for buttons to be pressed to call other funcions. 
        self.main_window = Tk()                                                     # creates main window
        self.main_window.title("Kyudoku Solver")                                    # title added to window                                      
        
        self.canvas = Canvas(self.main_window, height=550, width=550)               # sets height and width of window
        self.canvas.pack()                                                          # canvas.pack() renders the window

        self.background_frame = Frame(self.main_window, bg="#ffccb3")               # background frame is used to set background color
        self.background_frame.place(relx=0, rely=0, relwidth=1, relheight=1)        # .place() allows the frame to be proportionate when resizing window
        
        self.main_frame = Frame(self.main_window, bg="#ffccb3")
        self.main_frame.place(relx=.1, rely=.1, relwidth=.8, relheight=.8)

        self.title_frame = Frame(self.main_window, bg="#ffccb3")
        self.title_frame.place(relx= 0.5, rely=0, relwidth=0.8, relheight=0.1, anchor='n')

        self.footer_frame = Frame(self.main_window, bg="#ffccb3")
        self.footer_frame.place(relx=.5, rely=1, relwidth=.8, relheight=.1, anchor='s')
        
        self.photo = PhotoImage(file="kyudoku.gif")                                 # kyudoku.gif is located in same directory as GUI.py
        self.title = Label(self.title_frame, image=self.photo, bg = "#e64d00")      # image is displayed with a labeled
        self.title.place(relx=0.05, rely=.1, relwidth=.9, relheight=0.8)            # renders the image at top of window
        
        self.sel = [([0]*6) for i in range(6)]
        
        # Creates entry boxes used by the user to input the X,Y coordinates of the initial selected position
        self.start_sel_x = Entry(self.title_frame, bd=4, width=2, justify='center',font=("Helvetica",14),relief='groove',highlightcolor="#993300")
        self.start_sel_x.place(relx=.8, rely=.5, anchor='center')
        self.start_sel_x.insert(0,'X')                                              # the Entry box is filled with an 'X' to indicate X coordinate
        self.start_sel_y = Entry(self.title_frame, bd=4, width=2, justify='center',font=("Helvetica",14),relief='groove',highlightcolor="#993300")
        self.start_sel_y.place(relx=.895, rely=.5, anchor='center')
        self.start_sel_y.insert(0,'Y')                                              # the Entry box is filled with an 'Y' to indicate Y coordinate

        for i in range(6):                                                          # loop renders 36 colored backgrounds behind numbers to indicated selected posions
            for j in range(6):
                self.sel[i][j] = Label(self.main_frame, height=2, width=3, bg="#e64d00")
                self.sel[i][j].place(relx=i/6+.0125, rely=j/6+.0125, relwidth=1/6-.025, relheight=1/6-.025)


        self.cell = [([0]*6) for i in range(6)]                                     # 2D array is used to store the values input to each position

        for i in range(6):
            for j in range(6):                                                      # 36 Entry boxes are rendered to accept the input values from user
                self.cell[i][j] = Entry(self.main_frame, bd=4, justify='center', cursor='plus', font=("FONT",16),relief='groove',highlightcolor="#993300")
                self.cell[i][j].place(relx=i/6+.0375, rely=j/6+.0375, relwidth=1/6-.075, relheight=1/6-.075)
       
        self.solve_button = Button(self.footer_frame, text = 'Solve', command=self.solve)                           # calls solve() funcion
        self.solve_button.place(relx=.8, rely=.25, anchor='n')
        
        self.clear_button = Button(self.footer_frame, text = 'Clear',command=self.clear_board)                      # calls clear_board() funcion
        self.clear_button.place(relx=.2, rely=.25, anchor='n')

        self.instruction_button = Button(self.footer_frame, text = 'Instructions', command = self.instruction)      # calls instrucion() funcion
        self.instruction_button.place(relx=.5, rely=.25, anchor='n')
               
        mainloop()


    def instruciton_button_reset(self):
        # This funcion is used to preform two commands for the 'Start' button on the instruction window. 
        # This funcion used with the instrucion button configuration to 'disable' at the beginning of instrucion(), it can
        # be insured that only one instrucion window can be open a time.
        self.instruction_window.destroy()
        self.instruction_button.configure(state = 'normal')


    def instruction(self):
        # This is the funcion that is called when the 'Instrucion' button is pressed. A window labeled instructions is opened
        # and the instrucions on how to use the solver is displayed to the user. When the funcion is called, the 'Instrucion' button
        # in the main window is configured to a disabled state in order to only allow one instrucion window to open at a time.
        self.instruction_button.configure(state = 'disable')
        self.instruction_window = Tk()
        self.instruction_window.title("Instructions")
        instruction_canvas = Canvas(self.instruction_window, height=350, width=550)
        instruction_canvas.pack()
        instruction_background_frame = Frame(self.instruction_window, bg = "#ffccb3")
        instruction_background_frame.place(relx=0, rely=0, relwidth=1, relheight=1)
        instruction_title_frame = Frame(instruction_background_frame, bg="#e64d00")
        instruction_title_frame.place(relx = .5, rely = .1125, relwidth=0.65, relheight=0.15, anchor = 'center')
        instruction_title = Label(instruction_title_frame, text = "Instructions", bg = "#e64d00", justify='center',font=("Bookman Old Style",28))
        instruction_title.place(relwidth=1, relheight=1)
        scroll = Scrollbar(instruction_background_frame)
        text = Text(instruction_background_frame,bg = '#ffeee6', bd=4, height = 10, width=50, font=("Helvetica",14), relief='groove')
        scroll.place(relx = 0, anchor = 'e')
        text.place(relx = .5, rely = .5, anchor = 'center')
        text.insert(END,"1.  To begin, enter a number (1-9) in each position\n     corresponding with numbers given on a puzzle.\n\n")
        text.insert(END,"2.  Then enter the X,Y coordinate ((1,1) in top left) of the first\n     selected number on the puzzle.\n\n")
        text.insert(END,"3.  After all information is filled, click 'Solve' button to see\n     solution.\n\n\n")
        text.insert(END,"Copyright © 2019 Jake Gonzalez. All rights reserved.")
        scroll.configure(command = text.yview)
        text.configure(yscrollcommand = scroll.set)
        text.configure(state = 'disable')
        # 'Start' button will close the window and reconfigure the 'Instrucion' button to an active state by calling instrucion_button_reset()
        start_button = Button(instruction_background_frame, text = 'Start', command = self.instruciton_button_reset)
        start_button.place(relx = .5, rely = .85, anchor = 'center')

        self.instruction_window.mainloop()


    def clear_board(self):
        # This is the funcion that is clled when the 'Clear' button is clicked. It first reconfigures the state of the 'Solve'
        # button to normal in order for another puzzle to be solved.
        self.solve_button.configure(state = 'normal')
        self.clear_button.configure(state = 'normal')
        for i in range(6):                                              # loops through all cells in GUI
            for j in range(6):                                  
                self.cell[i][j].config(state=NORMAL)                    # changes the state of cells to normal
                self.cell[i][j].delete(0,END)                           # deletes the value in the cell
                self.sel[i][j].configure(bg="#e64d00")                  # changes the background to unselected
        self.start_sel_x.delete(0,END)                                  # starting X sel value is deleted
        self.start_sel_x.insert(0,'X')                                  # cell is filled with 'Y' again 
        self.start_sel_y.delete(0,END)                                  # starting Y sel value is deleted
        self.start_sel_y.insert(0,'Y')                                  # cell is filled with 'X'


    def create_input_file(self):
        # This funcion creates the file tempKyu.txt from the values input into the cells on the GUI.
        # The funcion checks if the inputs are valid, and retruns a boolean value for indication. If 
        # the input is not valid, the funcion will clear the inputs and returns an error window. The 
        # file tempKyu.txt is created regardless the inputs are valid or not, and is not deleted after the 
        # program is finished. 
        valid = True                                          
        fhandle = open('tempKyu.txt','w')                               # open the file for writing
        for i in range(6):                                              # loop through the cells on GUI
            for j in range(6):
                try:
                    value = int(self.cell[i][j].get())
                except:
                    self.error_message()
                    return
                if value > 0:                                           # if the cell is valid a line is written
                # to the file in the format of pos(N,X,Y) statements. 
                    fhandle.write('pos('+str(value)+','+str(i+1)+','+str(j+1)+').\n')
                else:                                                   # if the cell is not valid it is cleared 
                    self.cell[i][j].delete(0,END)   
                    valid = False                                       # flag data as invalid

        sel_x = int(self.start_sel_x.get())                             # starting selected cell is writen to file
        sel_y = int(self.start_sel_y.get())
        fhandle.write('sel('+str(sel_x)+','+str(sel_y)+').\n')          # format of sel(X,Y) statement
        fhandle.close()                                                 # file is closed
        if not valid:
            self.error_message()
        return valid                                                    # return the valid flag


    def error_window_button_reset(self):
        # This funcion is called by the 'Okay' button on the error window to destroy the error window and call
        # the clear_board() function
        self.error_window.destroy()
        self.clear_board()


    def error_message(self):
        # This function displays an error window promting the user that one or more given inputs were invalid
        self.solve_button.configure(state = 'disable')                  # solve button is changed to disable
        # to prevent multiple error windows from being opened.
        self.clear_button.configure(state = 'disable')                  # clear button is changed to disable
        # to prevent reactivating the solve button while error window is open.
        msg1 = "One or more input was invalid.\n"
        msg2 = "The board has been cleared."                                         
        self.error_window = Tk()
        self.error_window.title("Error!")
        error_canvas = Canvas(self.error_window, height = 125, width = 300)
        error_canvas.pack()
        error_background_frame = Frame(self.error_window, bg = "#ffccb3")
        error_background_frame.place(relheight = 1, relwidth = 1)
        label = Label(self.error_window, text=msg1+msg2, font=("Helvetica", 16), justify = 'center', bg = "#ffccb3")
        label.place(relx = .5, rely = .33, anchor = 'center')
        B1 = Button(self.error_window, text="Okay", command = self.error_window_button_reset)
        B1.place(relx = .5, rely = .75, anchor = 'center')
        self.error_window.mainloop()

        

    def display_output(self):
        # This funcion reads file kyuout.txt and displays the data in the GUI. The kyuout.txt file is created by
        # the output of mkatoms from clingo which contained the Kyudoku Solver. The file is formatted in 8 sel(x,y)
        # statements that is used to highlight the correct postions on the GUI.
        fhand2 = open('kyuout.lp','r')                                 # open the output file created by solver                        
        aspmodel = fhand2.readlines()                                   # read all the lines of the file into an array
        # if the first character of the file was an '*' it means the file does not contain an answer. A
        # message will be popped up to indicate this.
        if aspmodel[0][0] == '*':
            # Error messae is displayed                       
            msg = "No valid solution for given puzzle input."                                        
            popup = Tk()
            popup.wm_title("Error!")
            label = Label(popup, text=msg, font=("Helvetica", 16))
            label.pack(side="top", fill="x", pady=10)
            B1 = Button(popup, text="Okay", command = popup.destroy)
            B1.pack()
            popup.mainloop()
        else:                                                           # otherwise, if there was a solution                         
            for item in aspmodel:                                       # loop through tht srings from the file
                if item[0] == 's':                                      # the solution will be in sel(X,Y) statements 
                #indicaiting what posions to select. The sel(X,Y) statements are the only statements used in solution.
                    i = int(item[4])-1                                  # the 4th character indicates X
                    j = int(item[6])-1                                  # the 6th character indicates X
                    self.sel[i][j].configure(bg="#331100")              # sel lables are configured to changed to a 
                    #darker shade in order to display solution.
            self.solve_button.configure(state=DISABLED)                 # congigures 'Solve' button to disabled state


    def solve(self):
        # This funcion is called when the 'Solve' button is clicked. it calls the routine to create the input file from
        # the data provided to the GUI. If the data provided is valid, a system call is preformed to the Kyudoku solver
        # and then calls the display funcion to output solution to GUI.
        try:
            x = int(self.start_sel_x.get())
            y = int(self.start_sel_y.get())
        except:
            self.error_message()
            return                      
        for i in range(6):                                              # all cell inputs are changed to read only
            for j in range(6):                                          # this insures that inputs cannot be changed after     
                self.cell[i][j].configure(state="readonly")             # the solution is displayed.
        if self.create_input_file():
            system("clingo tempKyu.lp kyudokuforpy.lp | mkatoms > kyuout.lp")
            self.display_output()

KyudokuGUI()    # create GUI
