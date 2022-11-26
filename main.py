import pymysql

def db_connect():
    # prompt for username and password
    print("Please provide your MySQL username and password to enter the library database.")

    good_login = False
    while good_login is False:
        # TODO double check login error handling
        try:
            username = input("Username: ")
            password = input("Password: ")
            cnx = pymysql.connect(
                host='localhost', 
                user= username, 
                password= password,
                db='library_system', 
                charset='utf8mb4', 
                cursorclass= pymysql.cursors.DictCursor
            )
            good_login = True
            
        except Exception as e:
            print("Username or password is incorrect.")
            inpt = input("Type Q to quit or any other character to try again: ")
            if inpt.lower == 'q':
                exit()
        
    return cnx, username

def search_books(cursor):
    pass

def pay_fine(cursor):
    pass

def manage_members(cursor):
    pass

def book_checkout(cursor):
    pass

def book_return(cursor):
    pass

def add_book(cursor):
    # TODO add cancel option
    # TODO add data validation (in sql?)
    print("Add a book to the database using this menu! You'll be asked to" +
            "confirm details before submitting.")
    isbn = input("ISBN: ")
    title = input("Title: ")
    author_id = input("Author ID: ")
    genre = input("Genre: ")
    num_pages = input("Number of pages: ")
    year_published = input("Year published, formatted YYYY: ")
    publisher_id = input("Publisher ID: ")
    library_id = input("Library ID: "), 
    num_copies = input("Number of copies of this book to add to system: ")

    print(f"ISBN: {isbn} \nTitle: {title} \nAuthor ID: {author_id}" +
            "\nGenre{genre} \nNumber of pages: {num_pages}" +
            "\nYear published: {year_published} \nPublisher ID: " +
            "{publisher_id} \nLibrary ID{library_id} \nNumber of copies " +
            "to add: {num_copies}\n")
    
    good_input = False
    while good_input is False:
        choice = input("Type y and press enter to add to system or n to cancel: ")
        if choice.lower() == "y":
            stmt = "CALL add_book(%s, %s, %s, %s, %s, %s, %s, %s, %s);"
            cursor.execute(stmt, (isbn, title, author_id, genre, num_pages, 
                            year_published, publisher_id, library_id, num_copies))
            good_input = True
        elif choice.lower() == "n":
            good_input = True
            input("Book entry canceled. Press enter to return to the main menu.")

def mainloop():
    # connect to library_system
    cnx, username = db_connect()
    cur = cnx.cursor();
    print(f"Welcome to the inter-library database system, {username}!")
   
    options = {
        1: "Checkout book",
        2: "Return book", 
        3: "Add book(s) to system",
        4: "Search books", 
        5: "View overdue books",
        6: "View all late fees",
        7: "Pay fine",
        8: "View/manage members",
        0: "Quit",
        }

    # main looop
    quit_main_loop = False
    while quit_main_loop is False:
        print("Main menu. Type the corresponding number to continue.")
        for each in options:
            print(str(each) + ": " + options[each])
        choice = int(input("> "))

        match choice:
            case 0:
                quit_main_loop = True
            case 1:
                book_checkout(cur)
            case 2:
                book_return(cur)
            case 3:
                add_book(cur)
            case 4:
                search_books(cur)
            case 5:
                cur.execute("CALL view_all_overdue_books();")
            case 6:
                cur.execute("CALL view_all_late_fees();")
            case 7:
                pay_fine(cur)
            case 8:
                manage_members(cur)
            case _:
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the menu.")

    cur.close()
    cnx.close()

def main():
    mainloop()

if __name__ == "__main__" :
    main()
