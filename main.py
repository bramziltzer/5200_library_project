import pymysql

def main():
    # prompt for username and password
    print("Please provide your MySQL username and password to enter the library databse.")
    username = input("Username: ")
    password = input("Password: ")

    # connect to library_system
    # TODO login error handling
    
    '''cnx = pymysql.connect(
        host='localhost', 
        user= username, 
        password= password,
        db='library_system', 
        charset='utf8mb4', 
        cursorclass=pymysql.cursors.DictCursor
    )'''

    print(f"Welcome to the inter-library database system, {username}!")
    print("What would you like to do? Type the corresponding number to continue.")
    choice = input("1: Checkout book \n2: Return book \n3: Search books \n0 or Q: Quit")
    '''
    add books to system
    pay fine
    search all late fees and overdue books
    add/edit/remove member
    find book at different library
    '''
    match choice:
        case 1:


if __name__ == "__main__" :
    main()
