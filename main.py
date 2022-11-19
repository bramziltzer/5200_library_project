import pymysql

def db_connect():
    # prompt for username and password
    print("Please provide your MySQL username and password to enter the library databse.")
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
                cursorclass=pymysql.cursors.DictCursor
            )
            good_login = True

        except Exception as e:
            print("Username or password is incorrect.")
            inpt = input("Type Q to quit or any other character to try again: ")

            if inpt.lower == 'q':
                exit()
        
    return cnx, username

def main():

    # connect to library_system
    cnx, username = db_connect()
    
    print(f"Welcome to the inter-library database system, {username}!")
    quit_main_loop = False

    while quit_main_loop is False:
        print("What would you like to do? Type the corresponding number to continue.")
        choice = input("1: Checkout book \n2: Return book \n3: Search books \n0 or Q: Quit")
        '''
        add books to system
        pay fine
        search all late fees and overdue books
        add/edit/remove member
        find book at different library
        '''
        match choice.lower():
            case 0:
                quit_main_loop = True
            case 'q':
                quit_main_loop = True

    cnx.close()

if __name__ == "__main__" :
    main()
