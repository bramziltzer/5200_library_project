import pymysql

# TODO add try except to execute statements
def db_connect():
    # prompt for username and password
    print("Please provide your MySQL username and password to enter the library database.")

    good_login = False
    while not good_login:
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
            inpt = input("Type q to quit or any other character to try again: ")
            if inpt.lower() == 'q':
                exit()
        
    return cnx, username

def search_books(cursor):
    # TODO show list of available options before they search?
    quit_loop = False
    while not quit_loop:
        print("Book Search Menu. Type the corresponding number to continue.")
        print("0: Return to main menu \n1: Search by title \n2: Search by author \n3: Search by ISBN")
        choice = input("> ")
        
        match choice:
            case '0':
                quit_loop = True
            case '1':
                search_type = 'title'
                content = input("Title: ")
            case '2':
                search_type = 'author'
                content = input("Author: ")
            case '3':
                search_type = 'isbn'
                content = input("ISBN (13 digits): ")
            case _:
                content = None
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the search menu.")
                print()

        if content is not None:
            # TODO decide what to print, should include number of available books to checkout if any
            stmt = "CALL search_books(%s, %s);"
            cursor.execute(stmt, (search_type, content))
            data = cursor.fetchall()
            for each in data:
                print(each) # TODO formatting
            print()
            input = ("Press enter to return to search menu.")

def pay_fine(cursor):
    # TODO payment input validation
    print("Late Fee Payment Menu.")
    member = input("Member ID: ")
    cursor.execute("CALL search_one_member(%s)", member)
    data = cursor.fetchone()
    name = data.get("name")
    balance = data.get("fine_balance")

    print()
    print(f"Member: {name} \nLate Fee Balance: {balance}")
    print()
    payment = input("Enter payment amount: ")

    stmt = "CALL pay_late_fee(%s, %s);"
    cursor.execute(stmt, (member, payment))

    # return new balance
    cursor.execute("CALL search_one_member(%s)", member)
    data = cursor.fetchone()
    balance = data.get("fine_balance")
    print(f"{name}'s new balance: {balance}")

    print()
    input("Press enter to return to main menu.")

def manage_members(cursor):
    quit_loop = False
    while not quit_loop:
        print("Member Management Menu. Type the corresponding number to continue.")
        print("0: Return to main menu \n1: Add member \n2: Remove member")

        choice = input("> ")
        match choice:
            case '0':
                quit_loop = True
            
            # add member
            case '1':
                # TODO validate email?
                member_name = input("New member's full name: ")
                member_email = input("New member's email: ")
                stmt = "CALL add_member(%s, %s);"
                cursor.execute(stmt, (member_email, member_name))

                cursor.execute("SELECT * FROM member WHERE name = member_name AND email = member_email;")
                data = cursor.fetchone()
                new_id = data.get("member_id")
                print(f"Member added. Their new Member ID is: {new_id}")

            # remove member
            case '2':
                member_id = input("Member ID to delete: ")

                good_input = False
                while not good_input:
                    choice = input("Type y to delete member or n to cancel. THIS CAN'T BE UNDONE: ")
                    if choice.lower() == "y":
                        good_input = True
                        stmt = "CALL remove_member(%s)"
                        cursor.execute(stmt, member_id)
                        # TODO add confirmation or error message
                    elif choice.lower() == "n":
                        good_input = True
                        input("Member deletion canceled. Press enter to return to the member management menu.")
                    else:
                        print(f"{choice} is invalid!")

            # bad input
            case _:
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the member menu.")
                print()


def book_checkout(cursor):
    # TODO add validation
    print("Book Checkout Menu.")
    book_copy_id = input("Book Copy ID (Located on the sticker on the back of the book, NOT the ISBN): ")
    member_id = input("Member ID number: ")
    librarian_id = input("Librarian ID (your ID number): ")
    
    good_input = False
    while not good_input:
        choice = input("Type y and press enter to checkout book or n to cancel: ")
        if choice.lower() == "y":
            good_input = True
            stmt = "CALL check_out_books(%s, %s, %s);"
            cursor.execute(stmt, (book_copy_id, member_id, librarian_id))
        elif choice.lower() == "n":
            good_input = True
            input("Book checkout canceled. Press enter to return to the main menu.")
        else:
            print(f"{choice} is invalid!")


def book_return(cursor):
    # TODO add validation
    print("Book return menu.")
    book_copy_id = input("Book Copy ID to return (Located on the sticker on the back of the book, NOT the ISBN): ")
    good_input = False
    while not good_input:
        choice = input("Type y and press enter to return book or n to cancel: ")
        if choice.lower() == "y":
            good_input = True
            stmt = "CALL return_books(%s);"
            cursor.execute(stmt, book_copy_id)
        elif choice.lower() == "n":
            good_input = True
            input("Book return canceled. Press enter to return to the main menu.")
        else:
            print(f"{choice} is invalid!")
    

def add_book(cursor):
    # TODO add cancel option
    # TODO add data validation (in sql?)
    print("Add a book to the database using this menu. You'll be asked to " +
            "confirm details before submitting.")
    isbn = input("ISBN (13 digits): ")
    title = input("Title: ")
    author_id = input("Author ID: ")
    genre = input("Genre: ")
    num_pages = input("Number of pages: ")
    year_published = input("Year published, formatted YYYY: ")
    publisher_id = input("Publisher ID: ")
    library_id = input("Library ID: ")
    num_copies = input("Number of copies of this book to add to system: ")
    print()
    
    '''print()
    print("Your response:")
    print(f"ISBN: {isbn} \nTitle: {title} \nAuthor ID: {author_id}" +
            f"\nGenre{genre} \nNumber of pages: {num_pages}" +
            f"\nYear published: {year_published} \nPublisher ID: " +
            f"{publisher_id} \nLibrary ID: {library_id} \nNumber of copies " +
            f"to add: {num_copies}\n")
    '''
    
    good_input = False
    while not good_input:
        choice = input("Type y and press enter to add to system or n to cancel: ")
        if choice.lower() == "y":
            stmt = "CALL add_book(%s, %s, %s, %s, %s, %s, %s, %s, %s);"
            cursor.execute(stmt, (isbn, title, author_id, genre, num_pages, 
                            year_published, publisher_id, library_id, num_copies))
            good_input = True
        elif choice.lower() == "n":
            good_input = True
            input("Book entry canceled. Press enter to return to the main menu.")
        else:
            print(f"{choice} is invalid!")

def mainloop():
    # connect to library_system
    cnx, username = db_connect()
    cur = cnx.cursor();
    print()
    print(f"Welcome to the inter-library database system, {username}! This is for librarian access only!")
   
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
    while not quit_main_loop:
        print("\nMAIN MENU. Type the corresponding number to continue.")
        for each in options:
            print(str(each) + ": " + options[each])
        choice = input("> ")
        print()

        match choice:
            case '0':
                quit_main_loop = True
            case '1':
                book_checkout(cur)
            case '2':
                book_return(cur)
            case '3':
                add_book(cur)
            case '4':
                search_books(cur)
            case '5':
                cur.execute("CALL view_all_overdue_books();")
            case '6':
                cur.execute("CALL view_all_late_fees();")
            case '7':
                pay_fine(cur)
            case '8':
                manage_members(cur)
            case _:
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the menu.")

    print("\nExiting database. Goodbye!")
    cur.close()
    cnx.close()

def main():
    mainloop()

if __name__ == "__main__" :
    main()
