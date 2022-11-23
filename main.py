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
    quit_book_loop = False
    while quit_book_loop is False:
        choice = input()

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
