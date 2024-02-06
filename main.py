import tkinter as tk
from tkinter import ttk, font
from pyswip import Prolog


def open_popup(text_top, text_center):
    popup = tk.Toplevel()
    popup.title("Prolog Result")

    screen_width = popup.winfo_screenwidth()
    screen_height = popup.winfo_screenheight()
    window_width = 400

    text_max_size = max(len(text_top) , len(text_center))

    window_height = 200

    if text_max_size > 100:
        window_height = 400

    if text_max_size > 200:
        window_height = 500

    x = (screen_width - window_width) // 2
    y = (screen_height - window_height) // 2

    popup.geometry(f"{window_width}x{window_height}+{x}+{y}")

    label_top = tk.Label(popup, text=text_top)
    label_top.configure(font=font.Font(weight="bold"))
    label_top.place(relx=0.5, rely=0.2, anchor="center")  # Top-center alignment

    label_center = tk.Message(popup, text=text_center, width=200)
    label_center.pack()
    label_center.place(relx=0.5, rely=0.4, anchor="center")

    popup.mainloop()


dropdown_options = ("Desparte in silabe", "Verifica despartirea", "Genereaza cuvinte din silabe")


def option1_callback():
    global input_text
    prolog = Prolog()

    prolog.consult(filename='script.pl')
    result = list(prolog.query(f"desparte_in_silabe(\"{input_text.get()}\", Silabe)."))

    if len(result) > 0:
        silabe = result[0]['Silabe']  # [['a'], ['b', 'e'], ['c', 'e'], ['d', 'a', 'r']]
        output = ""

        for silaba_array in silabe:
            for silaba_chr in silaba_array:
                output += silaba_chr
            output += '-'

        #  remove last ending - because its redundant
        output = output[0:len(output) - 1]

        if len(output) > 0:
            open_popup("Despartirea in silabe este:", output)
        else:
            open_popup("Date de intrare invalide", "Introduceti un cuvant valid")


def structurare_string(input_string):
    string_structurat = ''
    for cuvant in input_string.split('-'):
        grup = ''
        for litera in cuvant:
            grup += litera + ','
        string_structurat += '[' + grup[:-1] + '], '
    return '[' + string_structurat[:-2] + ']'


def option2_callback():
    global input_text
    prolog = Prolog()

    inputString = structurare_string(input_text.get())

    prolog.consult(filename='script.pl')
    result = list(prolog.query(f"verificare_despartire_corecta({inputString}, Cuvant)."))

    print(f"verificare_despartire_corecta({inputString}, Cuvant).")
    print(result)

    if len(result) > 0:
        open_popup("Despartirea in silabe este corecta:", result[0]['Cuvant'])
    else:
        open_popup("Despartirea in silabe nu este corecta", "Mai incearca")


def option3_callback():
    global input_text
    prolog = Prolog()

    inputString = structurare_string(input_text.get())
    prolog.consult(filename='script.pl')
    result = list(prolog.query(f"permutare_lista_silabe({inputString}, Cuvinte)."))
    if len(result) > 0:
        output = ""

        permutari = result[0]['Cuvinte']
        for permutare in permutari:
            output += f"{permutare},"

        output = output[0: len(output) - 1]

        open_popup("Cuvintele generate sunt:", output)
    else:
        open_popup("Nu putem genera cuvinte", "Mai incearca")


def handle_button_click():
    global dropdown_value
    selected_option = dropdown_value.get()
    if selected_option == dropdown_options[0]:
        option1_callback()
    elif selected_option == dropdown_options[1]:
        option2_callback()
    elif selected_option == dropdown_options[2]:
        option3_callback()


root = tk.Tk()
root.title("Programare Bazata pe Reguli")

# Create input text
input_text = tk.StringVar()
input_text.set('')
input_entry = tk.Entry(root, textvariable=input_text)
input_entry.grid(row=0, column=0, padx=10, pady=10, sticky=tk.W)
input_entry.configure(background='#FFFFFF', relief='solid', width=20, borderwidth=1)  # Adjusted borderwidth

# Create dropdown
dropdown_value = tk.StringVar()
dropdown = ttk.Combobox(root, textvariable=dropdown_value)
dropdown.grid(row=0, column=1, padx=10, pady=10)
dropdown['values'] = dropdown_options
dropdown.current(0)
dropdown.configure(width=25)

# Create button
button = tk.Button(root, text="Submit", command=handle_button_click)
button.grid(row=0, column=2, columnspan=3, padx=10, pady=10)

# Apply styling
root.configure(background='#F0F0F0')

root.resizable(False, False)
root.mainloop()
