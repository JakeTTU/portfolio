#
#
#
#
#
#
#

import cv2
import face_recognition
import numpy as np
import datetime
from datetime import timedelta
from tkinter import *
import os

class Face_rec:
    def __init__(self):
        self.main_window = Tk()
        self.main_window.title("Attendance")
        self.canvas = Canvas(self.main_window, height=250, width=450)
        self.canvas.pack()
        self.background_frame = Frame(self.main_window, bg = "#d9e6f2")
        self.background_frame.place(relx=0, rely=0, relwidth=1, relheight=1)

        self.title_frame = Frame(self.background_frame, bg = "#d9e6f2")
        self.title_frame.place(relx=.5, rely=.125, relwidth=.85, relheight=.125, anchor = 'c')
        self.title_label = Label(self.title_frame, text = 'Class Attendance Recorder', justify='center',font=("Helvetica",28), bg='#d9e6f2')
        self.title_label.place(relx=.5, rely=.5, anchor='c')
        
        self.main_frame = Frame(self.background_frame,  bg = "#ecf2f9", )
        self.main_frame.place(relx = .5, rely= .55, relwidth = .85, relheight = .65, anchor = 'c')

        self.time_label = Label(self.main_frame, text = 'Enter run time in minutes:', bd=0, justify='left',font=("Helvetica",14), bg="#ecf2f9")
        self.time_label.place(relx = .05, rely = .6, anchor = 'w')

        self.time_entry = Entry(self.main_frame, bd=2, width=8, justify='center',font=("Helvetica",14),relief='groove',highlightcolor="black")
        self.time_entry.place(relx = .5, rely = .6, anchor = 'w')

        self.course_label = Label(self.main_frame, text = 'Enter name of course:', bd = 0, justify = 'left',font=("Helvetica",14),bg="#ecf2f9")
        self.course_label.place(relx = .05, rely = .275, anchor = 'w')

        self.course_entry = Entry(self.main_frame, bd=2, width=16, justify='center',font=("Helvetica",14),relief='groove',highlightcolor="black")
        self.course_entry.place(relx = .5, rely = .275, anchor = 'w')

        self.start_button = Button(self.main_frame, text = 'Start', command = self.face_rec)
        self.start_button.place(relx = .5, rely = .85, anchor = 'c')

        mainloop()



    def face_rec(self):
        # set desired runtime in minutes
        min_run = int(self.time_entry.get())
        start_time = datetime.datetime.now()
        end_time = start_time + timedelta(minutes = min_run)

        # video capture 0 will use default camera
        video_capture = cv2.VideoCapture(0)

        # run ./start_stream in ~/bin/ on raspberry ip to start video stream and get valid hostname
        #video_capture = cv2.VideoCapture('http://192.168.1.10:8080/?action=stream')

        #video_capture = cv2.VideoCapture('http://129.118.162.82:8080/?action=stream')
        
        # initialize variables
        face_locations = []
        face_encodings = []
        face_names = []
        present_names = []
        absent_names = []
        known_face_encodings = []
        known_face_names = []

        # load all .jpg images from directory to recognize face and display name
        for file in os.listdir():
            if file.endswith(".jpg"):
                image = face_recognition.load_image_file(file)
                face_encoding = face_recognition.face_encodings(image)[0]
                known_face_encodings.append(face_encoding)
                known_face_names.append(file[:-4])

        # used to process every second frame
        process_this_frame = True

        # get current date 
        date = datetime.datetime.now()

        # create a string for date with year month and day
        year = str(date.year)
        month = str(date.month)
        day = str(date.day)
        date1 = (year +'-'+ month +'-'+ day)

        # create a file unique to the day with course name
        course_name = self.course_entry.get()
        record_file = (course_name+'_'+date1+'_record.txt')
        f = open("records/"+record_file, 'w+')
        f.write('Arrival:\n')
        f.close()

        while True:
            # single frame is retrieved
            ret, frame = video_capture.read()

            # resize frame of video to .25 size for faster face recognition processing
            small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

            # convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
            rgb_small_frame = small_frame[:, :, ::-1]

            # process every second frame 
            if process_this_frame:
                # find all the faces and face encodings in the current frame of video
                face_locations = face_recognition.face_locations(rgb_small_frame)
                face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

                face_names = []
                for face_encoding in face_encodings:
                    # see if the face is a match for the known face(s)
                    matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
                    name = "Unknown"

                    # if a match was found in known_face_encodings, use the known face with the smallest distance to the new face
                    face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
                    best_match_index = np.argmin(face_distances)
                    if matches[best_match_index]:
                        name = known_face_names[best_match_index]

                        # check each line in report file for matched name
                        with open("records/"+record_file) as file:
                            datafile = file.readlines()
                        found = False
                        for line in datafile:
                            if name in line:
                                found = True
                                
                        # if name not yet in file
                        if not found:
                            # append name to present_names[]
                            present_names.append(name)

                            # write name and time of arrival to file 
                            f = open("records/"+record_file, 'a')
                            currentDT = datetime.datetime.now()
                            f.write(name + '\t' + str(currentDT) + '\n')
                            f.close()

                    face_names.append(name)
                    
            # alternate frames to process (only needed when a high framerate is used)
            #process_this_frame = not process_this_frame

            # display results
            for (top, right, bottom, left), name in zip(face_locations, face_names):
                # scale back up face locations since the frame we detected in was scaled to .25 size
                top *= 4
                right *= 4
                bottom *= 4
                left *= 4

                # draw a box around the face
                cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

                # draw a label with a name below the face
                cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
                font = cv2.FONT_HERSHEY_DUPLEX
                cv2.putText(frame, name, (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

            # display the resulting image
            cv2.imshow('Video', frame)

            # hit 'q' on the keyboard to quit
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

            curr_time = datetime.datetime.now()
            elap_time = curr_time - start_time

            print(elap_time)
            if curr_time >= end_time:
                break

        # open record file 
        f = open("records/"+record_file, 'a')

        # sort and write present names to file
        present_names.sort()
        f.write('\nPresent:\n')
        for name in present_names:
            f.write(name+'\n')

        # find absend names
        for name1 in known_face_names:
            found = False
            for name2 in present_names:
                if name1 == name2:
                    found = True
            if not found:
                absent_names.append(name1)
                
        # sort and write absent names to file
        absent_names.sort()
        f.write('\nAbsent:\n')
        for name in absent_names:
            f.write(name+'\n')
            
        f.close()

        # release handle camera
        video_capture.release()
        cv2.destroyAllWindows()

        
Face_rec()
