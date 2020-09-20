# Copyright © 2019 Jake Gonzalez. All rights reserved.
# Python graphical user interface for Answer Set Programming Fire Escape Route Solver
# by Jake Gonzalez
# Department of Computer Science
# Texas Tech University
# email: Jake.Gonzalez@ttu.edu
# Last updated: 7/02/19
#
# This program is a graphical user interface for a Fire Escape Route Solver for the first floor of the Livermore Center at
# Texas Tech University. Upon running the program, a GUI interface is displayed with a rendering of the Center's layout. The 
# layout contains entry boxes to state where the starting positon is on the map and were fires are located. An 's' is used to 
# represent the starting location, and a 'f' is used in any number of boxes and will block that tile from being used in the route.
# After the information has been input to the gui and thesolve button is clicked, a file with the informaion is created and is then
# sent to clingo to get the answer set. The output from clingo is fed to mkatoms to format the output in an easy to use format. 
# The file output from mkatoms is then read by the program, and the GUI displays the solution for the route to the nearest exit 
# (given all information was input correctly, and there is an exit route possible).
#
# There are three buttons on the GUI, 'Clear', 'Instructions', and 'Solve'. The 'Clear' button clears the layout of any inputs. The 
# 'Instructions' button opens another window which displays how to use the solver. The 'Solve' button calls the funcion to create 
# the input file and performs a system call to Clingo and MKAtoms. 
#
# Note: This program requires Python 3.7 or later and requires Clingo and MkAtoms be installed and in the user's system path. The program file 
# Kyudokuforpy.txt must be in the path or in the same directory as this program. This program creates two files when running, tempFire.txt and 
# fireout.txt. These files are not deleted after the program runs.

from tkinter import *
from os import system

class FireEscapeGUI():

	def __init__(self):
		# This funcion is used to initialte the GUI. A window is brought up and graphics are rendered. mainloop() allows
        # the funcion to display the GUI, add inputs, and wait for buttons to be pressed to call other funcions.
		self.main_window = Tk()														# creates main window
		self.main_window.title("Fire Escape Route")									# title added to window
		self.main_window.resizable(False,False)										# prohibits window resizing

		self.canvas = Canvas(self.main_window, height=711.7647, width=550)			# sets height and width of window
		self.canvas.pack()															# canvas.pack() renders the window

		self.main_frame = Frame(self.main_window)									# frame to hold the other graphics
		self.main_frame.place(relx=0, rely=0, relwidth=1, relheight=1)				# .place() allows the frame to be proportionate

		self.cell = [([0]*22) for i in range(17)]									# 2D array is used to hold the inputs of boxes

		self.steps = 1																# sets the possible number of steps to 1

		for i in range(17):															# creates all boxes in the layout
			for j in range(22):
				self.cell[i][j] = Entry(self.main_frame, bd = 0, justify = 'center', cursor='arrow')
				self.cell[i][j].place(relx=i/17, rely=j/22, relwidth=1/17, relheight=1/22)

		# labels with a width of 2 pixles are used to represent the walls in the layout
		self.wall_y1 = Label(self.main_frame, bg = 'black')
		self.wall_y1.place(relx=1/17, rely=3/22, width=2, relheight=18/22, anchor = 'n')
		self.wall_y2 = Label(self.main_frame, bg = 'black')
		self.wall_y2.place(relx=2/17, rely=1/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y3 = Label(self.main_frame, bg = 'black')
		self.wall_y3.place(relx=2/17, rely=17/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y4 = Label(self.main_frame, bg = 'black')
		self.wall_y4.place(relx=2/17, rely=20/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y5 = Label(self.main_frame, bg = 'black')
		self.wall_y5.place(relx=3/17, rely=6/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y6 = Label(self.main_frame, bg = 'black')
		self.wall_y6.place(relx=3/17, rely=9/22, width=2, relheight=3/22, anchor = 'n')
		self.wall_y7 = Label(self.main_frame, bg = 'black')
		self.wall_y7.place(relx=5/17, rely=2/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y8 = Label(self.main_frame, bg = 'black')
		self.wall_y8.place(relx=5/17, rely=8/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y9 = Label(self.main_frame, bg = 'black')
		self.wall_y9.place(relx=6/17, rely=2/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y10 = Label(self.main_frame, bg = 'black')
		self.wall_y10.place(relx=8/17, rely=17/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y11 = Label(self.main_frame, bg = 'black')
		self.wall_y11.place(relx=8/17, rely=19/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y12 = Label(self.main_frame, bg = 'black')
		self.wall_y12.place(relx=9/17, rely=1/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y13 = Label(self.main_frame, bg = 'black')
		self.wall_y13.place(relx=9/17, rely=13/22, width=2, relheight=1/22, anchor = 'n')
		self.wall_y14 = Label(self.main_frame, bg = 'black')
		self.wall_y14.place(relx=10/17, rely=17/22, width=2, relheight=3/22, anchor = 'n')
		self.wall_y15 = Label(self.main_frame, bg = 'black')
		self.wall_y15.place(relx=11/17, rely=1/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y16 = Label(self.main_frame, bg = 'black')
		self.wall_y16.place(relx=12/17, rely=6/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y17 = Label(self.main_frame, bg = 'black')
		self.wall_y17.place(relx=12/17, rely=9/22, width=2, relheight=3/22, anchor = 'n')
		self.wall_y18 = Label(self.main_frame, bg = 'black')
		self.wall_y18.place(relx=13/17, rely=1/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y19 = Label(self.main_frame, bg = 'black')
		self.wall_y19.place(relx=14/17, rely=3/22, width=2, relheight=11/22, anchor = 'n')
		self.wall_y20 = Label(self.main_frame, bg = 'black')
		self.wall_y20.place(relx=14/17, rely=15/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y21 = Label(self.main_frame, bg = 'black')
		self.wall_y21.place(relx=16/17, rely=12/22, width=2, relheight=2/22, anchor = 'n')
		self.wall_y22 = Label(self.main_frame, bg = 'black')
		self.wall_y22.place(relx=16/17, rely=15/22, width=2, relheight=2/22, anchor = 'n')

		self.wall_x1 = Label(self.main_frame, bg = 'black')
		self.wall_x1.place(relx=2/17, rely=1/22, relwidth=5/17, height=2, anchor = 'w')
		self.wall_x2 = Label(self.main_frame, bg = 'black')
		self.wall_x2.place(relx=8/17, rely=1/22, relwidth=5/17, height=2, anchor = 'w')
		self.wall_x3 = Label(self.main_frame, bg = 'black')
		self.wall_x3.place(relx=2/17, rely=2/22, relwidth=3/17, height=2, anchor = 'w')
		self.wall_x4 = Label(self.main_frame, bg = 'black')
		self.wall_x4.place(relx=1/17, rely=3/22, relwidth=6/17, height=2, anchor = 'w')
		self.wall_x5 = Label(self.main_frame, bg = 'black')
		self.wall_x5.place(relx=8/17, rely=3/22, relwidth=1/17, height=2, anchor = 'w')
		self.wall_x6 = Label(self.main_frame, bg = 'black')
		self.wall_x6.place(relx=10/17, rely=3/22, relwidth=2/17, height=2, anchor = 'w')
		self.wall_x7 = Label(self.main_frame, bg = 'black')
		self.wall_x7.place(relx=13/17, rely=3/22, relwidth=1/17, height=2, anchor = 'w')
		self.wall_x8 = Label(self.main_frame, bg = 'black')
		self.wall_x8.place(relx=3/17, rely=5/22, relwidth=9/17, height=2, anchor = 'w')
		self.wall_x9 = Label(self.main_frame, bg = 'black')
		self.wall_x9.place(relx=3/17, rely=8/22, relwidth=9/17, height=2, anchor = 'w')
		self.wall_x10 = Label(self.main_frame, bg = 'black')
		self.wall_x10.place(relx=3/17, rely=9/22, relwidth=9/17, height=2, anchor = 'w')
		self.wall_x11 = Label(self.main_frame, bg = 'black')
		self.wall_x11.place(relx=14/17, rely=12/22, relwidth=2/17, height=2, anchor = 'w')
		self.wall_x12 = Label(self.main_frame, bg = 'black')
		self.wall_x12.place(relx=3/17, rely=13/22, relwidth=9/17, height=2, anchor = 'w')
		self.wall_x13 = Label(self.main_frame, bg = 'black')
		self.wall_x13.place(relx=15/17, rely=14/22, relwidth=1/17, height=2, anchor = 'w')
		self.wall_x14 = Label(self.main_frame, bg = 'black')
		self.wall_x14.place(relx=15/17, rely=15/22, relwidth=1/17, height=2, anchor = 'w')
		self.wall_x15 = Label(self.main_frame, bg = 'black')
		self.wall_x15.place(relx=2/17, rely=17/22, relwidth=9/17, height=2, anchor = 'w')
		self.wall_x16 = Label(self.main_frame, bg = 'black')
		self.wall_x16.place(relx=12/17, rely=17/22, relwidth=4/17, height=2, anchor = 'w')
		self.wall_x17 = Label(self.main_frame, bg = 'black')
		self.wall_x17.place(relx=8/17, rely=19/22, relwidth=2/17, height=2, anchor = 'w')
		self.wall_x18 = Label(self.main_frame, bg = 'black')
		self.wall_x18.place(relx=1/17, rely=21/22, relwidth=9/17, height=2, anchor = 'w')

		self.cell[11][17].configure(bg = '#53c653')									# configres the 4 boxes of the exits to a green background
		self.cell[10][20].configure(bg = '#53c653')
		self.cell[16][14].configure(bg = '#53c653')
		self.cell[7][0].configure(bg = '#53c653')

		# 'Solve' button calls the solve() funcion
		self.button_solve = Button(self.main_frame, text = 'Solve', command = self.solve)
		self.button_solve.place(relx=14/17, rely=18.5/22, anchor = 'center')

		# 'Instructions' button calls the instructions() funcion
		self.button_instructions = Button(self.main_frame, text = 'Instructions', command = self.instructions)
		self.button_instructions.place(relx=14/17, rely=19.5/22, anchor = 'center')

		# 'Clear' button calls the clear() funcion
		self.button_clear = Button(self.main_frame, text = 'Clear', command = self.clear_board)
		self.button_clear.place(relx=14/17, rely=20.5/22, anchor = 'center')

		mainloop()


	def instruction_button_reset(self):
		# This funcion is used to reset the 'Instructions' button and destroy the instrucions window at the same time
		# when 'Start' button is pressed on instructions window
		self.instruction_window.destroy()
		self.button_instructions.configure(state = 'normal')


	def instructions(self):
		# This is the funcion that is called when the 'Instrucion' button is pressed. A window labeled instructions is opened
        # and the instrucions on how to use the solver is displayed to the user. When the funcion is called, the 'Instrucion' button
        # in the main window is configured to a disabled state in order to only allow one instrucion window to open at a time.
		self.button_instructions.configure(state = 'disable')
		self.instruction_window = Tk()
		self.instruction_window.title("Instructions")
		instruction_canvas = Canvas(self.instruction_window, height = 450, width = 550)
		instruction_canvas.pack()
		instruction_background_frame = Frame(self.instruction_window, bg = '#9fdf9f')
		instruction_background_frame.place(relwidth = 1, relheight = 1)
		instruction_title_frame = Frame(instruction_background_frame, bg = '#53c653')
		instruction_title_frame.place(relx = .5, rely = .1125, relwidth=0.65, relheight=0.15, anchor = 'center')
		instruction_title = Label(instruction_title_frame, text = "Instructions", bg = '#53c653', justify='center',font=("Bookman Old Style",28))
		instruction_title.place(relwidth=1, relheight=1)
		scroll = Scrollbar(instruction_background_frame)
		text = Text(instruction_background_frame,bg = '#ecf9ec' , bd=4, height = 15, width=50, font=("Helvetica",14), relief='groove')
		scroll.place(relx = 0, anchor = 'e')
		text.place(relx = .5, rely = .5, anchor = 'center')
		text.insert(END, "The map given is the layout of the first floor of the Livermore\nCenter at Texas Tech University. There are four exits to use\nin case of an emergency. Perform the following instructions\nto find a route to an exit.\n\n")
		text.insert(END, "1.   Enter 's' into one position to represent the starting\n      postion.\n\n")
		text.insert(END, "2.   Enter 'f' into any number of postions to represent a fire in\n      that location.\n\n")
		text.insert(END, "3.   Click 'Solve' botton display a route to an exit if one is\n      possible with the given inputs.\n\n\n")
		text.insert(END,"Copyright © 2019 Jake Gonzalez. All rights reserved.")
		scroll.configure(command = text.yview)
		text.configure(yscrollcommand = scroll.set)
		text.configure(state = 'disable')
		# 'Start' button will close the window and reconfigure the 'Instrucion' button to an active state by calling instrucion_button_reset()
		start_button = Button(instruction_background_frame, text = 'Start', command = self.instruction_button_reset)
		start_button.place(relx = .5, rely = .875, anchor = 'center')

		self.instruction_window.mainloop()


	def clear_board(self):
		# This is the funcion that is clled when the 'Clear' button is clicked. It first reconfigures the state of the 'Solve'
		# button to normal in order for another puzzle to be solved.
		self.button_solve.configure(state = 'normal')

		for i in range(17):														
			for j in range(22):
				self.cell[i][j].configure(bg = 'white', state = 'normal')		# changes all entry boxes' backgrounds to white
				self.cell[i][j].delete(0,END)									# deletes any informaion in boxes

		self.cell[11][17].configure(bg = '#53c653')								# changes the 4 exit boxes to green
		self.cell[10][20].configure(bg = '#53c653')
		self.cell[16][14].configure(bg = '#53c653')
		self.cell[7][0].configure(bg = '#53c653')


	def create_input_file(self):
		# This funcion creates the file tempFire.txt from the informaiton input into the cells on the GUI.
        # The funcion checks if the inputs are valid, and retruns a boolean value for indication. The 
        # file tempFire.txt is created regardless the inputs are valid or not, and is not deleted after the 
        # program is finished. 
		valid = True
		fhandle = open('tempFire.lp', 'w')										# opens the file for writing

		fhandle.write('step(0..'+str(self.steps)+').\n')						# loop through the cells on GUI
		for i in range(17):
			for j in range(22):
				ch = str(self.cell[i][j].get())
				if ch == 'f':					# fire is writen to the file in the locaion where 'f's are placed
					fhandle.write('fire('+str(i+1)+','+str(j+1)+').\n')
					self.cell[i][j].configure(bg = '#e60000')
				elif ch == 's':					# starting locaion is written to the file where an 's' is placed
					fhandle.write('holds(at('+str(i+1)+','+str(j+1)+'),0).\n')

		fhandle.close()															# close file
		return valid															# return valid flag


	def display_output(self):
		# This funcion reads file fireout.txt and displays the data in the GUI. The fireout.txt file is created by
        # the output of mkatoms from clingo which contained the FireEcapeRoute Solver. The file is formatted in stand((X,E,Y,E),T)
        # statements that is used to highlight the correct postions on the GUI to show the route found to the exit.
		fhands2 = open('fireout.lp', 'r')										# opens the output file created by the solver
		aspmodel = fhands2.readlines()											# read all the lines of the file into an array

		s = self.steps
		self.steps = 1

		for item in aspmodel:													# the stand(()) statements will start with 's'	
			if item[0] == 's':
				i = (int(item[7])-1)+(10*int(item[9]))							# sets value for x axis of cell
				j = (int(item[11])-1)+(10*int(item[13]))						# sets value for y axis of cell
				

				self.cell[i][j].configure(bg = '#53c653')						# cell x,y is changed to a green background

		self.button_solve.configure(state = 'disable')							# disables 'Solve' button

		

	def solve(self):
		# This funcion is called when the 'Solve' button is clicked. it calls the routine to create the input file from
        # the data provided to the GUI. A system call is preformed to the Kyudoku solver and then calls the display funcion 
        # to output solution to GUI.
		if self.create_input_file():
			system("clingo tempFire.lp fireEscapeASP3.lp | mkatoms > fireout.lp")	# system call using created file and file containging ASP code

		fhands2 = open('fireout.lp', 'r')												# opens the output file to read
		aspmodel = fhands2.readlines()													# reads all the lines ot the file ot an array

		if aspmodel[0][0] == '*':														# if no solution was found '*' will be the first char
			if self.steps < 200:														# max number of steps set
				self.steps = self.steps + 2												# two steps are added the the previously used number
				self.solve()															# recall the solve() funcion to see if there is a solution
			else:																		# if no solution is found with the max number of steps, an error
				self.steps = 1
				msg_error = "No possible route to exit."
				popup_error = Tk()
				popup_error.wm_title('Error!')
				label_error = Label(popup_error, text = msg_error, font = ("Helvetica", 16))
				label_error.pack(side='top', fill='x', pady=10)
				b1 = Button(popup_error, text='Okay', command = popup_error.destroy)
				b1.pack()
				popup_error.mainloop()

		else:
			self.display_output()														# if there is a solution, display() function is called



FireEscapeGUI()		# create GUI
