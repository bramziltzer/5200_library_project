import pymysql
from prettytable import PrettyTable

# TODO fix try except to execute statements- handle specific errors
def db_connect():
    # prompt for username and password
    print("Please provide your MySQL username and password to enter the library database.")

    good_login = False
    while not good_login:
        try:
            username = input("Username: ")
            password = input("Password: ")
            conn = pymysql.connect(
                host='localhost', 
                user= username, 
                password= password,
                db='library_system', 
                charset='utf8mb4', 
                cursorclass= pymysql.cursors.DictCursor,
                autocommit= True
            )
            good_login = True
            
        except Exception as e:
            print("Username or password is incorrect.")
            inpt = input("Type q to quit or any other character to try again: ")
            if inpt.lower() == 'q':
                exit()
    return conn, username

def search_books(conn):
    # TODO show list of available options before they search?
    quit_loop = False
    while not quit_loop:
        print("Book Search Menu. Type the corresponding number to continue.")
        print("0: Return to main menu \n1: Search by title \n2: Search by author \n3: Search by ISBN")
        choice = input("> ")
        
        match choice:
            case '0':
                quit_loop = True
                content = None
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
            with conn.cursor() as cursor:
                try:
                    stmt = "CALL search_books(%s, %s);"
                    cursor.execute(stmt, (search_type, content))
                    data = cursor.fetchall()
                    if not data:
                        print()
                        print(f"No results found for {search_type}: {content}")
                        print()
                    else:
                        table = PrettyTable()
                        table.field_names = ["Title", "Author(s)", "Genre", 
                            "ISBN", "Copy ID", "Publisher", "Published", 
                            "Library Branch", "Checked Out?"]
                        # TODO formatting
                        for each in data:
                            table.add_row([each['title'].title(), each['authors'], each['genre'],
                                each['isbn'], each['book_copy_id'], each['publisher_name'],
                                each['year_published'], each['library_name'], 
                                bool(int(each['is_checked_out']))])
                        print(table)
                        print()
                        input("Press enter to return to search menu.")
                except Exception as e:
                    print(e)


def pay_fine(conn):
    # TODO payment input validation
    print("Late Fee Payment Menu.")
    good_id = False
    while not good_id:
        member = input("Member ID: ")
        if member.isnumeric():
            good_id = True
        else:
            print("Member ID must be a number! Please try again")

    with conn.cursor() as cursor:
        try:
            cursor.execute("CALL search_one_member(%s)", member)
            data = cursor.fetchone()
            
            # if data is empty, no member found
            if not data:
                print()
                input(f"Member with ID {member} could not be found! Press enter to return to the main menu.")
            else:
                name = data.get("name")
                balance = data.get("fine_balance")

                print()
                print(f"Member: {name} \nLate Fee Balance: ${balance}")
                print()

                good_payment = False
                while not good_payment:
                    payment = input("Enter payment amount: ")
                    if float(payment) >= 0 and payment.replace('.', '', 1).isnumeric(): # decimal is allowed
                        good_payment = True
                    else:
                        print("Amount must be a non-negative integer! Please try again.")

                stmt = "CALL pay_late_fee(%s, %s);"
                cursor.execute(stmt, (member, payment))

                # return new balance
                cursor.execute("CALL search_one_member(%s)", member)
                data = cursor.fetchone()
                balance = data.get("fine_balance")
                print(f"{name}'s new balance: ${balance}")

                print()
                input("Press enter to return to main menu.")
        except Exception as e:
            print(e)
    

def manage_members(conn):
    quit_loop = False
    while not quit_loop:
        print("Member Management Menu. Type the corresponding number to continue.")
        print("0: Return to main menu \n1: Add member \n2: Remove member \n3: View all members")

        choice = input("> ")
        match choice:
            case '0':
                quit_loop = True
            
            # add member
            case '1':
                # TODO validate email?
                member_name = input("New member's full name: ")
                member_email = input("New member's email: ")

                with conn.cursor() as cursor:
                    try: 
                        stmt = "CALL add_member(%s, %s);"
                        cursor.execute(stmt, (member_email, member_name))
                        message = cursor.fetchone()

                        # print status message
                        print()
                        for each in message:
                            print(message[each])
                        print()
                        input("Press enter to return to the Member Management menu.")
                    except Exception as e:
                        print(e)
                
            # remove member
            case '2':
                member_id = input("Member ID to delete: ")

                good_input = False
                while not good_input:
                    choice = input("Type y to delete member or n to cancel. THIS CAN'T BE UNDONE: ")
                    if choice.lower() == "y":
                        good_input = True
                        with conn.cursor() as cursor:
                            try:
                                stmt = "CALL remove_member(%s)"
                                cursor.execute(stmt, member_id)
                                # TODO add confirmation or error message
                            except Exception as e:
                                print(e)
                    elif choice.lower() == "n":
                        good_input = True
                        input("Member deletion canceled. Press enter to return to the member management menu.")
                    else:
                        print(f"{choice} is invalid!")
            
            # view members
            case '3':
                with conn.cursor() as cursor:
                    try:
                        cursor.execute("SELECT * FROM member ORDER BY member_id;")
                        data = cursor.fetchall()
                        for each in data:
                            print(each)
                    except Exception as e:
                        print(e)

            # bad input
            case _:
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the member menu.")
                print()


def book_checkout(conn):
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
            with conn.cursor() as cursor:
                try:
                    stmt = "CALL check_out_books(%s, %s, %s);"
                    cursor.execute(stmt, (book_copy_id, member_id, librarian_id))
                    print()
                    print("Successfully added!") # TODO add better user feedback
                    print()
                except Exception as e:
                    print(e)
        elif choice.lower() == "n":
            good_input = True
            input("Book checkout canceled. Press enter to return to the main menu.")
        else:
            print(f"{choice} is invalid!")

def view_overdue_books(conn):
    with conn.cursor() as cursor:
        try:
            cursor.execute("CALL view_all_overdue_books();")
            data = cursor.fetchall()
            print("Overdue books:")
            for each in data:
                print(data)
        except Exception as e:
            print(e)
        print()
        input("Press enter to return to the main menu.")

def view_late_fees(conn):
    with conn.cursor() as cursor:
        try:
            cursor.execute("CALL view_all_late_fees();")
            data = cursor.fetchall()
            print("Members with late fees:")
            for each in data:
                print(data)
        except Exception as e:
            print(e)
        print()
        input("Press enter to return to the main menu.")
        
def book_return(conn):
    # TODO add validation
    print("Book return menu.")
    
    good_id = False
    while not good_id:
        book_copy_id = input("Book Copy ID to return (Located on the sticker on the back of the book, NOT the ISBN): ")
        if book_copy_id.isdigit():
            good_id = True
        else:
            print("Book Copy ID must be a number! Please try again.")
        
    good_input = False
    while not good_input:
        choice = input("Type y and press enter to return book or n to cancel: ")
        if choice.lower() == "y":
            good_input = True
            with conn.cursor() as cursor:
                try:
                    stmt = "CALL return_books(%s);"
                    cursor.execute(stmt, book_copy_id)
                    status = cursor.fetchone()
                    print()
                    for each in status:
                        print(status[each])
                    print()
                except Exception as e:
                    print(e)
            input("Press enter to return to the main menu.")

        elif choice.lower() == "n":
            good_input = True
            input("Book return canceled. Press enter to return to the main menu.")

        else:
            print(f"{choice} is invalid!")
    

def add_book(conn):
    print("Add a book to the database using this menu. You'll be asked to " +
            "confirm details before submitting.")
    
    # get isbn
    good_isbn = False
    while not good_isbn:
        isbn = input("ISBN (13 digits): ")
        if len(isbn) != 13 or not isbn.isnumeric():
            print("ISBN must be a 13 digit number! Please try again.")
        else:
            good_isbn = True

    title = input("Title: ")

    # validate author
    good_author = False
    while not good_author:
        author_id = input("Author ID: ")
        if author_id.isnumeric():
            good_author = True
        else:
            print("Author ID must be an integer! Please try again.")

    # select genre
    print("Available genres:")
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM genre_type;")
        data = cursor.fetchall()
        lst = []
        for i in range(len(data)):
            print(data[i]["genre"])
            lst.append(data[i]["genre"].lower())

    # validate genre
    good_genre = False
    while not good_genre:
        genre = input("Select one genre: ")
        if genre.lower() in lst:
            good_genre = True
        else:
            print(f"{genre} is not valid! Please try again.")
    print()
    
    # validate number of pages
    good_pages = False
    while not good_pages:
        num_pages = input("Number of pages: ")
        if num_pages.isnumeric() and int(num_pages) > 0:
            good_pages = True
        else:
            print(f"Number of pages must be a positive number! You entered {num_pages}.")
        
    # validate year_published
    good_year = False
    while not good_year:
        year_published = input("Year published, formatted YYYY: ")
        if len(year_published) == 4 and year_published.isnumeric():
            good_year = True
        else:
            print(f"Year published must be a 4 digit number! You entered {year_published}.")
    
    # validate publisher
    good_publisher = False
    while not good_publisher:
        publisher_id = input("Publisher ID: ")
        if publisher_id.isnumeric():
            good_publisher = True
        else:
            print("Publisher ID must be an integer! Please try again.")

    # validate library
    good_library = False
    while not good_library:
        library_id = input("Library ID: ")
        if library_id.isnumeric():
            good_library = True
        else:
            print("Library ID must be an integer! Please try again.")

    good_copies = False
    while not good_copies:
        num_copies = input("Number of copies of this book to add to system: ")
        if num_copies.isnumeric():
            good_copies = True
    print()

    # confirm entry into database
    good_input = False
    while not good_input:
        choice = input("Type y and press enter to add to system or n to cancel: ")
        if choice.lower() == "y":
            good_input = True
            with conn.cursor() as cursor:
                try:
                    stmt = "CALL add_book(%s, %s, %s, %s, %s, %s, %s, %s, %s);"
                    cursor.execute(stmt, (isbn, title, author_id, genre, num_pages, 
                                    year_published, publisher_id, library_id, num_copies))

                    # confirmation message
                    message = cursor.fetchone()
                    print()
                    for each in message:
                        print(message[each])
                    print()
                    print("Press enter to return to the main menu.")

                except Exception as e:
                    print(e)

        elif choice.lower() == "n":
            good_input = True
            input("Book entry canceled. Press enter to return to the main menu.")
        else:
            print(f"{choice} is invalid!")

def mainloop():
    # connect to library_system
    conn, username = db_connect()
    print()
    print(f"Welcome to the inter-library database system, {username}! This is for librarian access only!")
   
    options = {
        1: "Checkout book",
        2: "Return book", 
        3: "Add book(s) to system",
        4: "Search books", 
        5: "View overdue books",
        6: "View all late fees",
        7: "Pay late fee balance",
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
                book_checkout(conn)
            case '2':
                book_return(conn)
            case '3':
                add_book(conn)
            case '4':
                search_books(conn)
            case '5':
                view_overdue_books(conn)
            case '6':
                view_late_fees(conn)
            case '7':
                pay_fine(conn)
            case '8':
                manage_members(conn)
            case _:
                print()
                print(f"{choice} is invalid.")
                input("Press enter to return to the menu.")

    print("\nExiting database. Goodbye!")
    conn.close()

def main():
    mainloop()

if __name__ == "__main__" :
    main()

'''
To do:
- add search all books function

To fix:
- need to fetch error messages

To test:
- display error message for checking out checked out book
- need error message for payment < 0
- view overdue books
- need to fix the view late fees
- validation for add_book
- fetch error for add_book
- add_book genre validation
- add message for returning a book

Done:
- fix paying fines

NOTE- our add_book and search functionality doesn't support multiple authors but our schema does
'''