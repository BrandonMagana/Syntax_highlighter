from tkinter import messagebox
from numpy.testing._private.utils import measure
import pandas as pd
from random import choice, shuffle
from tkinter import *

current_card = {}
# -------------------   GETTING DATA FROM .CSV ------------------------- #
try:
    words_df = pd.read_csv("./data/words_to_learn.csv")
except FileNotFoundError:
    words_df = pd.read_csv("./data/english_words.csv")

vocabulario = words_df.to_dict("records")
shuffle(vocabulario)
#------------------------ BUTTONS FUNCTIONS ------------------------#
def next_word():
    global current_card, timer
    if len(vocabulario) > 0:
        window.after_cancel(timer)
        current_card = choice(vocabulario)
        canvas.itemconfig(language_lb,text="English",fill="black")
        canvas.itemconfig(word_lb,text=current_card["English"],fill="black")
        canvas.itemconfig(card, image=card_front)
        timer = window.after(3000,flip_card)
    else:
        win_message()
        
def win_message():
    canvas.itemconfig(language_lb,text="Congratulations!!",fill="black")
    canvas.itemconfig(word_lb,text="You've learn all 500 english words!",
                        fill="black", font=("Arial", 25, "bold"))
    canvas.itemconfig(card, image=card_front)
#---------------------- FLIP CARD --------------------------- # 
def flip_card():
    global current_card
    canvas.itemconfig(card, image=card_back)
    canvas.itemconfig(language_lb,text="Español", fill="white")
    canvas.itemconfig(word_lb,text=current_card["Espanol"], fill="white")

def is_known():
    global vocabulario
    global current_card
    if len(vocabulario) > 0:
        vocabulario.remove(current_card)
        next_word()
# -------------------- ON CLOSING -----------------------#
def on_closing():
    words_to_learn = pd.DataFrame(vocabulario)
    words_to_learn.to_csv("./data/words_to_learn.csv")
    window.destroy()
# -------------------   UI SETUP ------------------------- #
BACKGROUND_COLOR = "#B1DDC6"

window = Tk()
window.title("English Flashcards")
window.config(padx=50 , pady=50, background=BACKGROUND_COLOR)
if  len(vocabulario) > 0:
    timer = window.after(3000,flip_card)

canvas = Canvas(width = 800, height = 526, highlightthickness=0)
card_front = PhotoImage(file = "./images/card_front.png")
card_back = PhotoImage(file = "./images/card_back.png")
card = canvas.create_image(400,263 , image = card_front)
canvas.config(bg=BACKGROUND_COLOR)
language_lb=canvas.create_text(400,150,text="", font=("Arial",40, "italic"))
word_lb=canvas.create_text(400,263,text="", font=("Arial",60, "bold"))
canvas.grid(row=0,  column=0, columnspan=2)

wrong_img = PhotoImage(file = "./images/wrong.png")
unkwon_btn = Button(image=wrong_img, highlightthickness = 0, bd = 0, command=next_word) 
unkwon_btn.grid(row=1,column=0)

checked_img = PhotoImage(file = "./images/right.png")
known_btn = Button(image=checked_img, highlightthickness = 0, bd = 0, command=is_known) 
known_btn.grid(row=1,column=1)

next_word()

window.protocol("WM_DELETE_WINDOW", on_closing)

window.mainloop()